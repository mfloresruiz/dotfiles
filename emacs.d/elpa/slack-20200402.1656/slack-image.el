;;; slack-image.el ---                               -*- lexical-binding: t; -*-

;; Copyright (C) 2018

;; Author:  <yuya373@archlinux>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:
(require 'slack-util)
(require 'slack-team)

(defcustom slack-profile-image-file-directory temporary-file-directory
  "Default directory for slack profile images."
  :type 'string
  :group 'slack)

(defcustom slack-image-file-directory temporary-file-directory
  "Default directory for slack images."
  :type 'string
  :group 'slack)

(defcustom slack-image-max-height 300
  "Max Height of image.  nil is unlimited.  integer."
  :type 'integer
  :group 'slack)

(defcustom slack-render-image-p (display-graphic-p)
  "If t, images in messages are rendered"
  :type 'boolean
  :group 'slack)

(defun slack-image-path (image-url)
  (and image-url
       (expand-file-name
        (concat (md5 image-url)
                "."
                (file-name-extension image-url))
        slack-image-file-directory)))

(defun slack-image-slice (image)
  (when image
    (let* ((line-height 50.0)
           (height (or (plist-get (cdr image) :height)
                       (cdr (image-size image t))))
           (line-count (ceiling (/ height line-height)))
           (line (/ 1.0 line-count)))
      (if (< line-height height)
          (cl-loop for i from 0 to (- line-count 1)
                   collect (list (list 'slice 0 (* line i) 1.0 line)
                                 image))
        (list image)))))

(defun slack-image-shrink (image &optional max-height)
  (unless (image-type-available-p 'imagemagick)
    (error "Need Imagemagick"))
  (if max-height
      (let* ((data (plist-get (cdr image) :data))
             (file (plist-get (cdr image) :file))
             (size (image-size image t))
             (height (cdr size))
             (width (car size))
             (h (min height max-height))
             (w (if (< max-height height)
                    (ceiling
                     (* (/ (float max-height) height)
                        width))
                  width)))
        (create-image (or file data) 'imagemagick data :height h :width w))
    image))

(defun slack-mapconcat-images (images &optional pad)
  (when images
    (cl-labels
        ((sort-images (images)
                      (let ((compare (if (or (and (eq system-type 'darwin)
                                                  (< emacs-major-version 26))
                                             (< emacs-major-version 25))
                                         #'>
                                       #'<)))
                        (cl-sort images compare :key
                                 #'(lambda (image) (caddr (car image))))))
         (propertize-image (image)
                           (concat (or pad "")
                                   (propertize "image"
                                               'slack-image-display image
                                               'display image
                                               'face 'slack-profile-image-face))))
      (mapconcat #'propertize-image
                 (sort-images images)
                 "\n"))))

(defun slack-profile-image-path (image-url team)
  (expand-file-name
   (concat (md5 (concat (slack-team-name team) "-" image-url))
           "."
           (file-name-extension image-url))
   slack-profile-image-file-directory))

(cl-defun slack-image--create (path &key (width nil) (height nil) (max-height nil) (max-width nil))
  (let* ((imagemagick-available-p (image-type-available-p 'imagemagick))
         (image (apply #'create-image (append (list path (and imagemagick-available-p 'imagemagick) nil)
                                              (if height (list :height height))
                                              (if width (list :width width))
                                              (if max-height
                                                  (list :max-height max-height))
                                              (if max-width
                                                  (list :max-width max-width))))))
    (if (and (display-graphic-p) imagemagick-available-p)
        (slack-image-shrink image max-height)
      image)))

(defun slack-image-exists-p (image-spec)
  (file-exists-p (slack-image-path (car image-spec))))

(defun slack-image-string (spec &optional pad no-token)
  "SPEC: (list URL WIDTH HEIGHT MAX-HEIGHT MAX-WIDTH)"
  (if (and slack-render-image-p spec)
      (slack-if-let* ((path (slack-image-path (car spec))))
          (if (file-exists-p path)
              (slack-mapconcat-images
               (slack-image-slice
                (slack-image--create path
                                     :width (cadr spec)
                                     :height (caddr spec)
                                     :max-height (cadddr spec)
                                     :max-width (cadr (cdddr spec))))
               pad)
            (propertize "[Image]"
                        'slack-image-spec spec
                        'no-token no-token))
        "")
    ""))

(defun slack-render-image (image team)
  (let ((buf (get-buffer-create
              (format "*Slack - %s Image*" (slack-team-name team)))))
    (with-current-buffer buf
      (setq buffer-read-only nil)
      (erase-buffer)
      (if image
          (insert (slack-mapconcat-images (slack-image-slice image)))
        (insert "Loading Image..."))
      (setq buffer-read-only t)
      (goto-char (point-min)))

    buf))

(provide 'slack-image)
;;; slack-image.el ends here

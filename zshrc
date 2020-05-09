##########################################################################
# oh-my-zsh setup
##############################################################################

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.dotfiles/oh-my-zsh

# Set name of the theme to load.
# Look in $ZSH/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

#export ZSH_THEME='funky'
#export ZSH_THEME="pmcgee"
#export ZSH_THEME="junkfood"
#export ZSH_THEME="mikeh"
#export ZSH_THEME="bira"
#export ZSH_THEME="xiong-chiamiov"
export ZSH_THEME="xiong-chiamiov-plus"

# Set to this to use case-sensitive completion
export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# export DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.dotfiles/oh-my-zsh/plugins/*)
plugins=(git battery brew osx gradle ant compleat dirpersist gem ssh-agent cloudapp ruby textmate sublime)

source $ZSH/oh-my-zsh.sh

####################
# Environment mfr
####################
export MEGA=$HOME/MFR
export PROY=$MEGA/proyectos
export DEHO=$PROY/dehonline
export BILKY=$PROY/bilky
export CAPA=$PROY/capacitacion
export VM=$PROY/virtual-machines

export PATH=/Users/mfloresruiz/.composer/vendor/bin:$PATH

#GOTO  mfr
###########
alias to.personal='cd $MEGA/mfr-personal/'
alias to.proyectos='cd $PROY/'
alias to.dehonline='cd $HOME/Documents/dehonline-desarrollo'
alias to.git='cd $HOME/Documents/git'
alias to.bilky='cd $PROY/bilky/'
alias to.trading='cd $HOME/Documents/trading-desarrollo'
alias to.capacitacion='cd $CAPA/'
alias to.certibox='cd $HOME/Documents/certibox-desarrollo'

# Git alias
alias gl='git log --all --oneline --decorate --graph'
alias gb='git branch '
alias gc='git commit '
alias gf='git fetch -v '
alias gfp='git fetch --prune -v'
alias gr='git remote '
alias gs='git switch '
alias gp='git push '

# OTHER mfr alias
alias e=emacs
alias copy='cp -i'
alias move='mv -i'
alias c='clear'
alias musica-quizz='clear; java -jar $PROY/intervalos_musicales/proy/target/intervalos_musicales-1-jar-with-dependencies.jar;'

# PhpStorm
alias backup.PhpStormSettings='cp -r ~/Library/Preferences/WebIde90 $MEGA/plugins-preferences-softwares/phpstorm/'
alias restore.PhpStormSettings='cp -r $MEGA/plugins-preferences-softwares/phpstorm/WebIde90 ~/Library/Preferences/'
alias decrypt="java -jar ~/Documents/tools/cipher.jar  462D4A614E645267556B587032733576 --decrypt"

##############################################################################
# Boxen setup
##############################################################################
#source /opt/boxen/env.sh


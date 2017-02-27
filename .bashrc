[ -n "$PS1" ] && source ~/.bash_profile
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

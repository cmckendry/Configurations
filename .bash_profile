# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
  [ -r "$file" ] && source "$file"
done
unset file

# Unicode settings needed for linux
export LANG=en_US.UTF8
export GDM_LANG=en_US.UTF8

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Preserve real-time bash history in multiple terminal windows
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
  shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# Autocomplete Grunt commands
#which grunt &> /dev/null && eval "$(grunt --completion=bash)"

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion

# MacPorts Installer addition on 2012-10-12_at_15:58:56: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# Prevent the SUPER ANNOYING "temp file must be edited in place" error from crontab
alias crontab="VIM_CRONTAB=true crontab"

#alias wget="curl -O"

function vpn-connect {
echo "tell application \"System Events\"
  tell current location of network preferences
    set VPN to service \"1stDibs\" -- your VPN name here
    if exists VPN then connect VPN
    repeat while (current configuration of VPN is not connected)
      delay 1
    end repeat
  end tell
end tell" | /usr/bin/env osascript
}

function vpn-disconnect {
"tell application \"System Events\"
  tell current location of network preferences
    set VPN to service \"1stDibs\" -- your VPN name here
    if exists VPN then disconnect VPN
  end tell
end tell" | /usr/bin/env osascript
}

cd ~/Configurations && git pull &> /dev/null && git submodule update --init --recursive &> /dev/null &
disown $!
cd

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh

if [ -f ~/Configurations/secrets/.secrets ]; then
    source ~/Configurations/secrets/.secrets
else
    git clone git@github.com:cmckendry/secrets.git ~/Configurations/secrets > /dev/null
    source ~/Configurations/secrets/.secrets
fi

## Passwordless SSH "phone home" functionality
## SUPER HACKY
# Grap epoch time for use as a (good enough) unique ID
#export NOW=`date +%s`
#if [ -z "$LC_IDENTIFICATION" ]; then
#    # Generate the key/save to tmp file
#    ssh-keygen -q -t rsa -N "" -f /tmp/$NOW
#    # Drop the private key into an env variable
#    export LC_IDENTIFICATION=`cat /tmp/$NOW`
#    # Add the public key
#    cat /tmp/$NOW.pub | sed "s/$USER@`hostname`/$NOW/" >> ~/.ssh/authorized_keys
#    # Clean up
#    rm -f /tmp/$NOW*
#else
#    echo $LC_IDENTIFICATION | awk '{ for(i=4 ;i<30 ;i++) $i = $i"\n"}1' | head -n 26 > /tmp/$NOW
#    echo '-----END RSA PRIVATE KEY-----' >> /tmp/$NOW
#    chmod 400 /tmp/$NOW
#    export HOME_KEY=/tmp/$NOW
#    # Be careful not to get into a weird...loop thing
#    unset LC_IDENTIFICATION
#fi

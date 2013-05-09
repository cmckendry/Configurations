# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
  [ -r "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
  shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

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

cd ~/Configurations && git pull > /dev/null && cd

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh

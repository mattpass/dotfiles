# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions

# Custom prompts 1 & 2
export PS1="\n\e[0;32m[\u@\h]\$\n\w \e[m"
export PS2="\n\e[0;33m[>] \e\m"

# Show all files
function l() {
        ls -a -l --block-size=\'1 --color=auto
}

# Change dir and l
function c() {
        cd "$@" && l
}

# Easier navigation: cd to .., ..., .... ~ & http dir, all with lsa
alias ..="c .."
alias ...="c ../.."
alias ....="c ../../.."
alias ~="c ~"
alias http="c /srv/http"
alias tree="tree -a -C"

# Save us from killing root
alias rm="rm --preserve-root"

# Reload the shell (i.e. invoke as a login shell with .bash_profile, which likely this file)
# switch -l to -i if you just want to reload this file
alias rebash="exec $SHELL -l"

# Nano this file, .inputrc or .nanorc
alias profile="sudo nano ~/.bashrc"
alias input="sudo nano ~/.inputrc"
alias nanorc="sudo nano ~/.nanorc"

# Display memory info totals
alias meminfo="free -m -l -t"

# Reload Nginx or PHP FPM
alias nginxt="sudo nginx -t"
alias nginxr="sudo service nginx reload"
alias phpr="sudo service php-fpm restart"

# Go to nginx or php-fpm dirs
alias gonginx="c /etc/nginx/conf.d/"
alias gophp="c /etc/php-fpm.d/"

# List of users
alias userslist='cat /etc/passwd |grep "/bin/bash" |grep "[5-9][0-9][0-9]" |cut -d: -f1'

# List of all users with UID
function userslistall() {
        awk -F":" '{ print "username: " $1 "\t\tuid:" $3 }' /etc/passwd
}

# Create a new dir and enter it
function mkd() {
        mkdir -p "$@" && cd "$@"
}

# Sudo nano a file
function edit() {
        sudo nano "$@"
}

# Remove a dir and everything inside
function killdir() {
        sudo rm -rf "$@"
}

# Zip this dir recursively
function zipthis() {
        thisdir=${PWD##*/}
        sudo zip -r $thisdir.zip .
}

# Get a file following to end point, from sites such as mailbigfile.com
# argument must be within double quotes when called
function getzip() {
        curl -o file.zip -L "$@"
}

# List the sub dir sizes in human readable format as a summary
function dirsizes() {
        sudo du -h -s *
}
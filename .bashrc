# .bashrc

printf '===========================\nTop 5 CPU processes (col 3)\n===========================\n'
ps aux | sort -rk 3,3 | head -n 6

printf '\n==============================\nTop 5 memory processes (col 4)\n==============================\n'
ps aux | sort -rk 4,4 | head -n 6

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions

# Check all dirs from project root for dirty git dirs
function gitdirty() {
    local PREVDIR="$(pwd)"
    local OUTPUT=""
    PROJECTSROOT="/media/matt/data"
    cd "$PROJECTSROOT"
    for DIR in *;
    do
        if [[ $DIR != "lost+found" ]] && [ -d "$PROJECTSROOT/$DIR/.git" ]; then
            cd "$PROJECTSROOT/$DIR"
            local GITSTATUS="$(git status 2> /dev/null | tail -n1)"
            if [[ $GITSTATUS != "nothing to commit, working tree clean" ]]; then
                local GITBRANCH="$(git branch | grep \* | cut -d ' ' -f2)"
                local GITSTAT="$(git show --stat | awk 'END{print}')"
                OUTPUT="$OUTPUT\e[30;32m$DIR\e[0m\t : \e[30;34m$GITBRANCH\e[0m\t :\e[30;33m$GITSTAT\e[0m\n"
            fi
        fi
    done
    echo -e $OUTPUT | column -t -s $'\t'
    cd $PREVDIR
}

# Parse git dirty
function parsegitdirty {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]] && echo " : dirty"
}

# Parse git branch (and if dirty)
function parsegitbranch {
    local GITBRANCH="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parsegitdirty)/")"
    if [[ $GITBRANCH != "" ]]; then
        echo -e " \e[0;44m ($GITBRANCH)"
    fi
}

# Get number of files behind compared to same branch on origin
function gitbehind() {
        if [ -d ".git" ]; then
                local GITBRANCHNAME="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e "s/* //")"
                # git fetch
                local HEADHASH=$(git rev-parse HEAD)
                local UPSTREAMHASH=$(git rev-parse $GITBRANCHNAME@{upstream})
                if [ "$HEADHASH" != "$UPSTREAMHASH" ]; then
                        local NUMFILESCHANGED="$(git diff $GITBRANCHNAME origin/$GITBRANCHNAME --name-only | wc -l)"
                        if [ "$NUMFILESCHANGED" != "0" ]; then
                                echo -e "\e[0;41m $NUMFILESCHANGED files behind origin \e[0;32m"
                        fi
                fi
        fi
}

# Custom prompts 1 & 2
export PS1="\n\e[30;42m \u \e[30;43m \w\$(parsegitbranch) \$(gitbehind)\e[0;32m\n└─▶ "
export PS2="\n\e[0;32m[\u@\h]\$\n\w \e[m"
# Use debug to reset color back to white before output display
trap 'echo -n "$(tput sgr0)"' DEBUG

# Show all files
function l() {
        ls -a -l --block-size=\'1 --color=auto
}

# Change dir and l
function c() {
        cd "$@" && l
        if [ -d ".git" ] && [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]]; then
            git status
        fi

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

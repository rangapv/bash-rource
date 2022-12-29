_scr()
{
   source <(curl -s https://raw.githubusercontent.com/rangapv/bash-source/main/bashdb.sh) >>/dev/null 2>&1
   local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="${!array[@]}"
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}
complete -o nospace -F _scr ./setup.sh 

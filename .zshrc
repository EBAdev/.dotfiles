export PATH=$PATH:/Users/emil/bin

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/emil/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/emil/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/emil/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/emil/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# PYTHON PATHS
# IFPY
export PYTHONPATH=${PYTHONPATH}:"/Users/emil/Documents/AU/3. Semester/Investering og Finansiering/"

# Simplex
export PYTHONPATH=${PYTHONPATH}:"/Users/emil/Documents/AU/3. Semester/Lineær optimering/"

# global python
export PYTHONPATH=${PYTHONPATH}:"/Users/emil/.global_py_scripts"  


#### Shell command alias ####

# quick uni cd
alias au="cd ~/Documents/AU/4.\ Semester/"
alias au1="cd ~/Documents/AU/1.\ Semester/"
alias au2="cd ~/Documents/AU/2.\ Semester/"
alias au3="cd ~/Documents/AU/3.\ Semester/"

alias mø="ccmø; cd ~/Documents/AU/4.\ Semester/Mikroøkonomi\ 2/"
alias mat="ccmat; cd ~/Documents/AU/4.\ Semester/Matematisk\ Statistik/"
alias prog="cd ~/Documents/AU/4.\ Semester/Introduktion\ til\ programmering/"

# current course
alias ccmø="ln -sfn ~/Documents/AU/4.\ Semester/Mikroøkonomi\ 2/Notes ~/.current_course"
alias ccmat="ln -sfn ~/Documents/AU/4.\ Semester/Matematisk\ Statistik/Noter  ~/.current_course"

# NEW CD command, changes current course also.
function cc() {
  local abs_path
  abs_path=$(pwd)
  ln -sfn "$abs_path/$1" ~/.current_course && cd "$1"
}

# NEW function mknote creates a note directory and figures directory inside.
function mknote(){
  mkdir "$1" && mkdir "$1/figures"
}

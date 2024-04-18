# export PATH="$PATH:~/mysrc/Todo.go/bin"
# export PATH="$PATH:~/development/flutter/bin"

set -x PATH $PATH ~/mysrc/Todo.go/bin
set -x PATH $PATH ~/development/flutter/bin
set -x PATH $PATH ~/.rvm/bin

if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_prompt -d "Write out the prompt"
    #  printf '%s@%s %s%s%s > ' $USER $hostname (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)

    # Foldername > 
    # printf '%s > ' (prompt_pwd)

    set -l last_status $status
    set_color $fish_color_cwd
    printf '%s' (prompt_pwd)
    set_color normal
    printf '%s ' (__fish_git_prompt)
    set_color normal
    echo -n '> '
end

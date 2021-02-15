
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
status is-interactive && eval /Users/sadanand/opt/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

function _tide_item_virtual_env
    if set -l splitVirtualEnv (string split '/' "$CONDA_PREFIX")
        set_color $tide_virtual_env_color

        if test "$tide_virtual_env_display_mode" = 'venvName'
            printf '%s' $tide_virtual_env_icon' ' $splitVirtualEnv[-1]
        else # Default to projectName
            printf '%s' $tide_virtual_env_icon' ' $splitVirtualEnv[-1]
        end
    end
end

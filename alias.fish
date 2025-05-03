#!/usr/bin/env fish

# @fish-lsp-disable 2002 4004

# options
argparse --stop-nonopt h/help q/quiet persistent-autoload c/completions alias-only script-path -- $argv
or return

# erase any clashing abbr
if abbr -q flc
    abbr --erase flc
end

# erase any clashing functions
if functions -aq flc
    functions --erase flc
end

alias flc 'NVIM_APPNAME=fish-lsp-language-clients nvim'

# check if the script was executed correctly
# set -l current_command (status current-filename)
# if test -z "$current_command" && not set -q _flag_quiet
#     echo "Warning please source the script, directly executing might not work" >&2
#     echo "Use one of the commands below: " >&2
#     for command in $possible_commands
#         echo " >_ source $(status current-filename)" >&2
#     end
#     exit 1
# end

if set -ql _flag_alias_only
    alias flc 'NVIM_APPNAME=fish-lsp-language-clients nvim'
    if not set -q _flag_quiet
        echo "alias flc 'NVIM_APPNAME=fish-lsp-language-clients nvim'"
    end
    return
end

if set -ql _flag_script_path
    echo "$(path resolve (status current-filename))"
    return
end

# show help message
if set -ql _flag_help
    set -l commandstring "$(path resolve (status current-filename) | string replace "$HOME" '~')"
    echo "NAME: $commandstring"
    echo ''
    echo 'SYNOPSIS:'
    echo ''
    echo "  $commandstring [OPTIONS]"
    echo "  source $commandstring [OPTIONS]"
    echo ''
    echo 'DESCRIPTION:'
    echo ''
    echo '  This script creates an alias for the fish-lsp-language-clients nvim client.'
    echo '  It also includes lots of utilities to help customize how the alias is used.'
    echo ''
    echo 'OPTIONS:'
    echo ''
    echo '  -h, --help                     show help message'
    echo '  -q, --quiet                    don\'t output anything'
    echo '  --persistent-autoload          autoload whenever ~/.config/fish-lsp-language-clients'
    echo '                                 is entered (pipe to `funcsave` if you want this always enabled)'
    echo '                                 if you save this function, you will have to call it in your fish startup'
    echo '  -c, --completions              show completions for the alias'
    echo '  --alias-only                   output the alias'
    echo '  --script-path                  output the script path'
    echo ''
    echo 'USAGE:'
    echo ''
    echo ' Source the alias'
    echo ' >_ ./alias.fish'
    echo ''
    echo ' Use the alias'
    echo ' >_ flc ~/.config/fish/config.fish'
    echo ''
    echo ' Test the --persistent-autoload flag for your current interactive shell'
    echo ' >_ source ./alias.fish --persistent-autoload | source'
    echo ''
    echo ' Save the alias to your fish config using one of the two commands:'
    echo ''
    echo ' 1.) Only source the alias when inside the client directory. This is useful if you have other commands named `flc'
    echo ' >_ ./alias.fish --persistent-autoload > $fish_config_dir/conf.d/fish-lsp-language-clients.fish'
    echo ''
    echo ' 2.) Always source the alias. This is useful if you don\'t have any other commands named `flc`'
    echo ' >_ ./alias.fish --alias-only > $fish_config_dir/conf.d/fish-lsp-language-clients.fish'
    echo ''
    return
end

# handle silence option
if not set -ql _flag_quiet && not set -ql _flag_persistent_autoload && not set -ql _flag_completions
    echo 'alias flc \'NVIM_APPNAME=fish-lsp-language-clients nvim\''
end

set script_path ~/.config/fish-lsp-language-clients/alias.fish

function output_completions_for_script --description "output completions for the $script_path"
    echo "complete -p $script_path -f"
    echo "complete -p $script_path -n '__fish_use_subcommand' -a '
    -h\t\'show the help output\'
    --help\t\'show the help output\'
    --q\t\'silence the output\'
    --quiet\t\'silence the output\'
    --persistent-autoload\t\'autoload whenever ~/.config/fish-lsp-language-clients is entered\'
    -c\t\'show completions\'
    --completions\t\'show completions\'
    --alias-only\t\'output the alias\'
    --script-path\t\'output the script path\''"
    echo "complete -p $script_path -s h -l help                -d 'show help message'"
    echo "complete -p $script_path -s q -l quiet               -d 'silence the output'"
    echo "complete -p $script_path      -l persistent-autoload -d 'autoload whenever ~/.config/fish-lsp-language-clients is entered'"
    echo "complete -p $script_path -s c -l completions         -d 'output completions for the alias.fish script'"
    echo "complete -p $script_path      -l alias-only          -d 'output the alias'"
    echo "complete -p $script_path      -l script-path         -d 'output the script path'"
end

if set -ql _flag_completions
    # check if the script was executed correctly
    output_completions_for_script
    return
end

if set -ql _flag_persistent_autoload
    # function to add to autoloaded fish startup
    function __check_lsp_dir --on-variable PWD --description 'will autoload the fish-lsp-client script when entering the ~/.config/fish-lsp-language-clients directory or a fish-lsp git repo'

        # We could also allow the flc alias to be globally available
        # by adding the alias to the autoloaded fish config.
        #
        # To use this approach instead:
        # `./alias.fish --alias-only > ~/.config/fish/conf.d/flc.fish`
        functions --erase flc

        # Check if the current directory is a git repo
        if not command -aq git
            return
        end
        if not git rev-parse --show-toplevel &>/dev/null
            return
        end

        set -l repo_name "$(git remote -v | sed -rn '1s#.*/(.*)\.git.*#\1#p')"

        # Load the alias if either condition was met
        if string match -eq -- 'fish-lsp-language-clients' "$PWD" || string match -q -- "$repo_name" 'fish-lsp'
            # We've entered the target directory or a fish-lsp git repo
            set script_path "$(path resolve ~/.config/fish-lsp-language-clients/alias.fish)"
            if test -f $script_path
                source $script_path --alias-only -q
            end
            return
        else
            if functions -aq flc
                functions --all --erase flc
            end
            if abbr -q flc
                abbr --erase flc
            end
        end
    end

    echo -e '# built from the fish-lsp-language-clients `alias.fish` script\n'
    functions --verbose __check_lsp_dir
    echo -e '\n# call the function during startup so that the hook listens to \$PWD changes'
    echo __check_lsp_dir

    echo -e '\n# the completions for using the alias.fish script'
    output_completions_for_script
end

###
### WARNING: this nuked my shada files so might be deprecated???
###
# if set -ql _flag_install_sync_packer
#   string repeat '-' -c 50
#   nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' -c 'messages'
#   string repeat '-' -c 50
# end

# alias flc 'NVIM_APPNAME=fish-lsp-language-clients nvim'

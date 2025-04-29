#!/usr/bin/env fish

# @fish-lsp-disable 2002

# options
argparse --stop-nonopt h/help q/quiet -- $argv
or return

# erase any clashing functions
if functions -aq flc
    functions --erase flc
end

# erase any clashing abbr
if abbr -q flc
    abbr -e flc
end

# check if the script was executed correctly
set -l current_command (status current-command)
if test "source" != "$current_command"
    echo "Warning please source the script, directly executing might not work" >&2
    echo "Use `>_ source alias.fish`" >&2
    exit 1
end

# show help message
if set -ql _flag_help
    echo 'USAGE:'
    echo ' >_ source ./alias.fish            # source the alias'
    echo ' >_ flc ~/.config/fish/config.fish # use the alias'
    echo ''
    echo 'OPTIONS:'
    echo '  -h, --help                     show help message'
    echo '  -q, --quiet                    don\'t output anything'
    return
end

# handle silence option
if not set -ql _flag_quiet
    echo 'alias flc \'NVIM_APPNAME=fish-lsp-language-clients nvim\''
end

###
### WARNING: this nuked my shada files so might be deprecated???
###
# if set -ql _flag_install_sync_packer
#   string repeat '-' -c 50
#   nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' -c 'messages'
#   string repeat '-' -c 50
# end

alias flc 'NVIM_APPNAME=fish-lsp-language-clients nvim'

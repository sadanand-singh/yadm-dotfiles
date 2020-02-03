function update -d "update brew, fish, fisher and mac app store"
    echo 'start updating ...'

    echo 'updating Ubuntu'
    sudo apt update
    sudo apt upgrade
    sudo apt autoremove
    sudo apt-get clean
    sudo apt-get autoclean

    echo 'updating fish shell'
    fisher
    fish_update_completions
end

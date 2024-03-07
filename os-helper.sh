
#!/bin/bash

# Set the OS version
osVersion=<OS Version>
installerPath="install macOS Sonoma.app"  # Update this with the correct installer path for Sonoma

# Define Sonoma task
function run_sonoma_task() {
    sonoma run --name "Install macOS" --path "/Applications/$installerPath/Contents/Resources/startosinstall" \
    --args "--agreetolicense --forcequitapps --nointeraction --user <Username> --stdinpass" \
    --password <Password>
}

# Fetch full installer using softwareupdate
softwareupdate --fetch-full-installer –full-installer-version $osVersion

# Run Sonoma task
run_sonoma_task

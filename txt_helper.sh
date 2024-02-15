
links=( "https://zoom.us/client/5.17.5.29101/zoomusInstallerFull.pkg" "https://vscode.download.prss.microsoft.com/dbazure/download/stable/31c37ee8f63491495ac49e43b8544550fbae4533/VSCode-darwin-universal.zip" "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg" "https://downloads.arduino.cc/arduino-ide/arduino-ide_latest_macOS_64bit.dmg" "https://redirector.gvt1.com/edgedl/android/studio/install/2023.1.1.28/android-studio-2023.1.1.28-mac.dmg")
arm_links=( "https://zoom.us/client/5.17.5.29101/zoomusInstallerFull.pkg" "https://vscode.download.prss.microsoft.com/dbazure/download/stable/31c37ee8f63491495ac49e43b8544550fbae4533/VSCode-darwin-universal.zip" "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg" "https://downloads.arduino.cc/arduino-ide/arduino-ide_latest_macOS_64bit.dmg" "https://redirector.gvt1.com/edgedl/android/studio/install/2023.1.1.28/android-studio-2023.1.1.28-mac_arm.dmg")
packages=( "zoomusInstallerFull.pkg" "VSCode-darwin-universal.zip" "" "" ""  )

EXTENSION_DIR="$HOME/.vscode/extensions"
# Create the extension directory if it doesn't exist
mkdir -p "$EXTENSION_DIR"


brew install wget

function unzip_package() {
    local i=$1
    wget "${links[$i]}"
    unzip "${packages[$i]}" -d /Applications
}

function damage_installer() {
    wget "${links[$i]}"
} 

function package_installer() {
    local i="$1"
    local link="${links[$i]}"
    if [[ "$(uname -m)" != "x86_64" ]]; then
        link="${arm_links[$i]}"
    fi
    wget "${link}"
    sudo installer -pkg "${packages[$i]}" -target ../
}

for i in "${!links[@]}"; do
    if [[ "${links[i]}" == *".pkg"* ]]; then    package_installer "$i"

    elif [[  "${links[i]}" == *".dmg"*  ]]; then 
        damage_installer "$i"
    else

        unzip_package "$i"
            fi
done

# VS code configurations
chmod +x setup.sh


# List of extensions to install
extensions=(
    "vscode-icons-team.vscode-icons"
    "ms-vsliveshare.vsliveshare"
    "esbenp.prettier-vscode"
    "ecmel.vscode-html-css"
    "xabikos.JavaScriptSnippets"
    "ms-vscode.vscode-typescript-next"
    "dsznajder.es7-react-js-snippets"
    "dsznajder.es7-react-js-snippets"
    "burkeholland.simple-react-snippets"
    "quicktype.quicktype"
)
for extension in "${extensions[@]}"; do
    echo "Installing $extension..."
    code --install-extension "$extension"
done

# Move installed extensions to the appropriate directory
mv ~/.vscode/extensions/* "$EXTENSION_DIR"


echo "Setup complete!"

rm -rf *.pkg

rm -rf *.zip
echo "Finished Installing"

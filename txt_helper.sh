

links=( "https://zoom.us/client/5.17.5.29101/zoomusInstallerFull.pkg" "https://vscode.download.prss.microsoft.com/dbazure/download/stable/31c37ee8f63491495ac49e43b8544550fbae4533/VSCode-darwin-universal.zip" "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg" "https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.1_macOS_64bit.dmg" "https://redirector.gvt1.com/edgedl/android/studio/install/2023.1.1.28/android-studio-2023.1.1.28-mac.dmg" "https://download.jetbrains.com/python/pycharm-community-2023.3.3.dmg" "https://dl.pstmn.io/download/latest/osx_64" "https://download.studio3t.com/studio-3t/mac/2024.1.0/Studio-3T.dmg" "https://repo.anaconda.com/archive/Anaconda3-2023.09-0-MacOSX-x86_64.pkg" "https://downloads.slack-edge.com/releases/macos/4.36.140/prod/universal/Slack-4.36.140-macOS.dmg" "https://www.figma.com/download/desktop/mac")
arm_links=( "https://zoom.us/client/5.17.5.29101/zoomusInstallerFull.pkg" "https://vscode.download.prss.microsoft.com/dbazure/download/stable/31c37ee8f63491495ac49e43b8544550fbae4533/VSCode-darwin-universal.zip" "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg" "https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.1_macOS_arm64.dmg" "https://redirector.gvt1.com/edgedl/android/studio/install/2023.1.1.28/android-studio-2023.1.1.28-mac_arm.dmg" "https://download.jetbrains.com/python/pycharm-community-2023.3.3.dmg" "https://dl.pstmn.io/download/latest/osx_arm64" "https://download.studio3t.com/studio-3t/mac/2024.1.0/Studio-3T.dmg" "https://repo.anaconda.com/archive/Anaconda3-2023.09-0-MacOSX-arm64.pkg" "https://downloads.slack-edge.com/releases/macos/4.36.140/prod/universal/Slack-4.36.140-macOS.dmg" "https://www.figma.com/download/desktop/mac")
packages=( "zoomusInstallerFull.pkg" "VSCode-darwin-universal.zip" "googlechrome.dmg" "arduino-ide.dmg" "android-studio.dmg" "pycharm.dmg" "postman.zip" "Studio-3T.dmg" "anaconda.pkg" "slack.dmg" "figma.dmg")
function package_installer() {
    local i="$1"
    echo "$i"
    local link="${links[$i]}"
    if [[ "$(uname -m)" != "x86_64" ]]; then
        link="${arm_links[$i]}"
    fi
    wget "${link}" -O "${packages[$i]}"
    sudo installer -pkg "${packages[$i]}" -target ../
}

EXTENSION_DIR="$HOME/.vscode/extensions"
# Create the extension directory if it doesn't exist
mkdir -p "$EXTENSION_DIR"


# Install xcode
xcode-select --install

# install brew 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile



# install git
brew install git
echo 'export PATH="/usr/local/bin:${PATH}"' >> ~/.zshrc
echo 'export PATH="/opt/homebrew/bin:${PATH}"' >> ~/.bash_profile


# install yarn
npm i -g yarn truffle

# the following code is to remove the python bloat
cd /Library

# removing python
sudo rm -rf Python

cd /Applications

# removing python in applications
sudo rm -rf Python.app

# remove python frameworks
sudo rm -rf /Library/Frameworks/Python.framework

# remove python binary
sudo rm -rf /usr/local/bin/python

cd ~/Desktop
#wget https://repo.anaconda.com/archive/Anaconda3-2023.09-0-MacOSX-x86_64.pkg // get arm link


brew install wget

function unzip_package() {
    local i=$1
    # -O so that the output is always the same 
    wget "${links[$i]}" -O "${packages[$i]}"
    unzip "${packages[$i]}" -d /Applications
}

function damage_installer() {
    local i=$1
    wget "${links[$i]}" -O "${packages[$i]}"
} 



for i in "${!links[@]}"; do
    if [[ "${links[i]}" == *".pkg"* ]]; then    package_installer "$i"

    elif [[  "${links[i]}" == *".dmg"*  ]]; then 
        damage_installer "$i"
    else

        unzip_package "$i"
            fi
done
touch setup.sh
# VS code configurations
chmod +x setup.sh


sudo ln -s /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code /usr/local/bin/code
# List of extensions to instal
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
sleep 10
 an_link="${links[8]}"
    if [[ "$(uname -m)" != "x86_64" ]]; then
        an_link="${arm_links[8]}"
    fi
wget "${an_link}" -O "${packages[8]}"
sleep 50

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash


echo "Finished Installing"
 
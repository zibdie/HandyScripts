#cat /usr/local/bin/software_upgrade
brew update
brew upgrade
brew upgrade --cask
brew upgrade --cask warp
brew upgrade --cask dbeaver-community
flutter channel stable
flutter upgrade --force
rustup update
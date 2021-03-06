#!/usr/bin/env bash
# 
# Bootstrap script for setting up a new OSX machine
# 
# This should be idempotent so it can be run multiple times.
#
# Some apps don't have a cask and so still need to be installed by hand. These
# include:
#
# - Twitter (app store)
# - Postgres.app (http://postgresapp.com/)
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#
# Reading:
#
# - https://github.com/Homebrew/homebrew-cask/blob/master/USAGE.md
# - http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://news.ycombinator.com/item?id=8402079
# - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/

echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

PACKAGES=(
    bash
    git
    gradle
    jq
    maven
    nodejs
    npm
    postgresql
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

echo "Tapping cask..."
brew tap homebrew/cask

CASKS=(
    3cxphone
    calibre
    firefox
    flux
    google-backup-and-sync
    google-chrome
    icons8
    insomnia
    iterm2
    intellij-idea-ce
    jetbrains-toolbox
    jprofiler
    lastpass
    phpstorm
    reaper
    slack
    soapui
    sourcetree
    spotify
    tunnelblick
    TuxGuitar
    vlc
    vnc-viewer
    zerotier-one
)

echo "Installing cask apps..."
brew cask install ${CASKS[@]}


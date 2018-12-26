$EMAIL_ADDRESS = "me@example.com"
$FULL_NAME = "John Smith"

# Install software-properties-common
sudo apt install -y software-properties-common

# Install fish
sudo apt-add-repository ppa:fish-shell/release-2
sudo apt update
sudo apt install -y fish

# Use fish
chsh -s /usr/bin/fish

# Install xclip
sudo apt install -y xclip

# Install git
sudo apt-add-repository ppa:git-core/ppa
sudo apt update
sudo apt install -y git

# Configure git
git config --global user.email $EMAIL_ADDRESS
git config --global user.name $FULL_NAME

ssh-keygen -t rsa -b 8192 -C $EMAIL_ADDRESS
xclip -sel clip < ~/.ssh/github_rsa.pub

# Install Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install -y google-chrome-stable

# Install vim
sudo apt install -y vim

# Install rustup
curl https://sh.rustup.rs -sSf | sh


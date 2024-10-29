# Script to check if kubeadm and kubectl are installed
# and copy conf to user .kube/ directory from root or other location
#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if kubeadm and kubectl are installed
if command_exists kubeadm && command_exists kubectl; then
    echo "kubeadm and kubectl are already installed."
else
    # Prompt the user to install kubeadm and kubectl if they are not installed
    read -p "kubeadm and/or kubectl are not installed. Would you like to install them? (y/n): " install_choice
    if [ "$install_choice" == "y" || "$install_choice" == "Y" ]; then
        # Install kubeadm and kubectl
        echo "Installing kubeadm and kubectl..."
        sudo apt update
        sudo apt install -y apt-transport-https ca-certificates curl gpg
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
        echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
        sudo apt-get update
        sudo apt-get install -y kubeadm kubectl
        sudo apt-mark hold kubeadm kubectl
        echo "kubeadm and kubectl have been installed."
    else
        echo "kubeadm and kubectl are required to continue. Exiting."
        exit 1
    fi
fi

# Define the default path for admin.conf
DEFAULT_CONFIG_PATH="/etc/kubernetes/admin.conf"
LOCAL_CONFIG_PATH="./config"
LOCAL_ADMIN_CONF="./admin.conf"

# Check if the admin.conf file exists at the default path
if [ -f "$DEFAULT_CONFIG_PATH" ]; then
    CONFIG_PATH="$DEFAULT_CONFIG_PATH"
    echo "Using admin.conf from $DEFAULT_CONFIG_PATH."
# Check if there is a 'config' file in the current directory
elif [ -f "$LOCAL_CONFIG_PATH" ]; then
    CONFIG_PATH="$LOCAL_CONFIG_PATH"
    echo "Using config file found in the current directory."
# Check if there is an 'admin.conf' file in the current directory
elif [ -f "$LOCAL_ADMIN_CONF" ]; then
    CONFIG_PATH="$LOCAL_ADMIN_CONF"
    echo "Using admin.conf file found in the current directory."
else
    # If no suitable file is found, prompt the user for the location
    echo "admin.conf not found at $DEFAULT_CONFIG_PATH or in the current directory."
    read -p "Please enter the path to your admin.conf or config file: " CONFIG_PATH

    # Verify if the provided path exists
    if [ ! -f "$CONFIG_PATH" ]; then
        echo "File not found at the specified location. Exiting."
        exit 1
    fi
fi

# Create the .kube directory in the home directory if it doesn't exist
mkdir -p $HOME/.kube

# Copy the Kubernetes configuration file to the .kube directory
sudo cp -i "$CONFIG_PATH" $HOME/.kube/config

# Change the ownership of the .kube/config file to the current user
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Kubernetes config setup completed successfully."


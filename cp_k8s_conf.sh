# Script to copy conf to user .kube/ directory from root or other 
#!/bin/bash

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

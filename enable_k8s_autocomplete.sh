#!/bin/bash

# Function to check if a command exists
function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if kubectl is installed
if ! command_exists kubectl; then
    echo "kubectl is not installed. Please install kubectl before running this script."
    exit 1
fi

# Check if kubeadm is installed
if ! command_exists kubeadm; then
    echo "kubeadm is not installed. Please install kubeadm before running this script."
    exit 1
fi

# Enable kubectl autocompletion for bash
echo "Enabling kubectl autocompletion..."
if ! grep -Fxq "source <(kubectl completion bash)" ~/.bashrc; then
    echo 'source <(kubectl completion bash)' >> ~/.bashrc
    echo "Added kubectl completion to ~/.bashrc"
else
    echo "kubectl completion already enabled in ~/.bashrc"
fi

# Enable kubeadm autocompletion for bash
echo "Enabling kubeadm autocompletion..."
if ! grep -Fxq "source <(kubeadm completion bash)" ~/.bashrc; then
    echo 'source <(kubeadm completion bash)' >> ~/.bashrc
    echo "Added kubeadm completion to ~/.bashrc"
else
    echo "kubeadm completion already enabled in ~/.bashrc"
fi

# Add alias 'k' for 'kubectl' and set up autocompletion for it
echo "Adding alias 'k' for 'kubectl'..."
if ! grep -Fxq "alias k=kubectl" ~/.bashrc; then
    echo 'alias k=kubectl' >> ~/.bashrc
    echo "Added alias 'k=kubectl' to ~/.bashrc"
else
    echo "Alias 'k=kubectl' already exists in ~/.bashrc"
fi

# Set up autocompletion for the alias 'k'
echo "Setting up autocompletion for 'k' alias..."
if ! grep -Fxq "complete -o default -F __start_kubectl k" ~/.bashrc; then
    echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc
    echo "Added autocompletion for alias 'k' in ~/.bashrc"
else
    echo "Autocompletion for alias 'k' already enabled in ~/.bashrc"
fi

# Apply the changes
echo "Applying changes by sourcing ~/.bashrc..."
source ~/.bashrc

echo "Autocompletion and alias setup complete for kubectl and kubeadm!"

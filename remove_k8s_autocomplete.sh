#!/bin/bash

# Remove kubectl and kubeadm autocompletion lines from ~/.bashrc
sed -i '/source <(kubectl completion bash)/d' ~/.bashrc
sed -i '/source <(kubeadm completion bash)/d' ~/.bashrc
sed -i '/alias k=kubectl/d' ~/.bashrc
sed -i '/complete -o default -F __start_kubectl k/d' ~/.bashrc

# Reload bashrc to apply changes
echo "Reloading ~/.bashrc to apply changes..."
source ~/.bashrc

echo "kubectl and kubeadm autocompletion and alias removed from ~/.bashrc."

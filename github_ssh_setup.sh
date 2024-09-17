#!/bin/bash

# Define SSH directory
SSH_DIR="$HOME/.ssh"

# Create SSH directory if it doesn't exist
mkdir -p $SSH_DIR
chmod 700 $SSH_DIR

# Function to prompt for input
prompt_input() {
    local prompt="$1"
    local var_name="$2"
    read -p "$prompt" $var_name
}

# Array to store account information
declare -a accounts

# Prompt user for account information
while true; do
    prompt_input "Enter username (or 'done' to finish): " username
    [ "$username" = "done" ] && break

    prompt_input "Enter user email: " email
    prompt_input "Enter namespace for host: " namespace

    key_file="id_rsa_${username}"
    accounts+=("$username:$email:$namespace:$key_file")
done

# Generate SSH keys and configure ~/.ssh/config
for account in "${accounts[@]}"; do
    IFS=":" read -r username email namespace key_file <<<"$account"

    # Generate SSH key for the account
    ssh-keygen -t rsa -b 4096 -C "$email" -f "$SSH_DIR/$key_file" -N ""

    # Add key to SSH agent
    eval "$(ssh-agent -s)"
    ssh-add "$SSH_DIR/$key_file"

    # Append SSH config entry for this account
    cat >>"$SSH_DIR/config" <<EOL

# $username GitHub account
Host $namespace
  HostName github.com
  User git
  IdentityFile $SSH_DIR/$key_file
  IdentitiesOnly yes

EOL

    # Print the public key
    echo ""
    echo "Public SSH key for $username:"
    cat "$SSH_DIR/$key_file.pub"
    echo ""
done

# Set proper permissions for the config file
chmod 600 "$SSH_DIR/config"

echo "SSH keys and config for GitHub accounts have been generated and added to $SSH_DIR/config."

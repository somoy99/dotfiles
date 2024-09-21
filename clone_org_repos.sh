#!/bin/bash

# Check if required arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <directory> <namespace> <organization> <github_token>"
    exit 1
fi

DIRECTORY=$1
NAMESPACE=$2
ORG=$3
TOKEN=$4

# GitHub API URL
API_URL="https://api.github.com"

# Get list of repository names (including private ones)
repos=$(curl -s -H "Authorization: token ${TOKEN}" "${API_URL}/orgs/${ORG}/repos?type=all&per_page=100" | grep -oP '"name": "\K(.*)(?=")')

# Check if any repositories were found
if [ -z "$repos" ]; then
    echo "No repositories found or no access to repositories for the organization ${ORG}"
    exit 1
fi

# Create directory structure if it doesn't exist
mkdir -p "${DIRECTORY}/${ORG}"
cd "${DIRECTORY}/${ORG}"

# Clone each repository
echo "Cloning repositories for ${ORG} into ${DIRECTORY}/${ORG}..."
echo "$repos" | while read -r repo_name; do
    echo "Cloning ${repo_name}"
    git clone "git@${NAMESPACE}:${ORG}/${repo_name}.git"
done

echo "All accessible repositories have been cloned."
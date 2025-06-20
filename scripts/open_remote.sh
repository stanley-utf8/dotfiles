#!/usr/bin/env bash

# Open the current repository in the browser
dir=$(tmux display-message -p "#{pane_current_path}")
cd "$dir"
url=$(git remote get-url origin)
url_branch=$(git branch --show-current)

# Check if the repository is on GitHub or Autodesk
if [[ $url == *"github.com"* ]] || [[ $url == *"git.autodesk.com"* ]]; then
  # Convert SSH URL to HTTPS if necessary
  if [[ $url == git@* ]]; then
    url=$(echo "$url" | sed 's/git@\(.*\):/https:\/\/\1\//')
  fi

  if [[ ! -z $url_branch ]]; then
    if [[ $url_branch != "master" && $url_branch != "main" ]]; then
      url=${url%.git} # rm git suffix if present
      url="$url/tree/$url_branch"
    fi
  fi

  open "$url"
else
  echo "This repository is not hosted on GitHub or Autodesk Git"
  exit 1
fi

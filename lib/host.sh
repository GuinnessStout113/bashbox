#!/usr/bin/env bash

# Host mode for bashbox

run_host() {
  clear

  echo -e "\033[1;35m====================================\033[0m"
  echo -e "\033[1;35m        🎉  B A S H B O X  🎉        \033[0m"
  echo -e "\033[1;35m====================================\033[0m"
  echo
  echo -e "\033[1;32mHost mode started.\033[0m"
  echo -e "Game: \033[1mQuiplash (prototype)\033[0m"
  echo
  echo -e "\033[1;36mWaiting for players to join...\033[0m"
  echo -e "\033[2m(Press Ctrl+C to stop the server)\033[0m"
  echo

  # Placeholder host loop
  while true; do
    sleep 2
    echo -e "\033[2m[$(date +%H:%M:%S)] still waiting...\033[0m"
  done
}
``
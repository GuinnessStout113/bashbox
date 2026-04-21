#!/usr/bin/env bash

# Host mode for bashbox

PROMPT="Worst thing to name a production server"
PHASE="COLLECTING_ANSWERS"

PLAYERS=("Guinness")
ANSWERS=()
``

run_host() {
  clear

  echo -e "\033[1;35m====================================\033[0m"
  echo -e "\033[1;35m        🎉  B A S H B O X  🎉        \033[0m"
  echo -e "\033[1;35m====================================\033[0m"
  echo
  echo -e "\033[1;32mHost mode started.\033[0m"
  echo -e "Game: \033[1mQuiplash (prototype)\033[0m"
  echo
  echo -e "\033[1;33mPrompt:\033[0m \033[1m$PROMPT\033[0m"
  echo
  echo -e "\033[36mSubmit your answer using:\033[0m"
  echo -e "  \033[1msubmit \"your answer\"\033[0m"
  echo -e "\033[2m(Press Ctrl+C to stop the server)\033[0m"
  echo

  # Placeholder host loop
  while true; do  
    echo -n "> "
    read -r line  
    handle_command "$line"
  done
}

handle_command() {
  local input="$1"
  local cmd
  local args

  cmd="${input%% *}"
  args="${input#"$cmd"}"
  args="${args#" "}"

  case "$cmd" in
    submit)
      handle_submit "$args"
      ;;
    help)
      echo "Available commands:"
      echo "  submit \"your answer\""
      ;;
    *)
      echo "Unknown command. Type 'help' for options."
      ;;
  esac
}

handle_submit() {
  local answer="$1"

  if [[ "$PHASE" != "COLLECTING_ANSWERS" ]]; then
    echo "Not accepting answers right now."
    return
  fi

  if [[ -z "$answer" ]]; then
    echo "Usage: submit \"your answer\""
    return
  fi

  ANSWERS+=("$answer")

  echo -e "\033[32mAnswer received ✅\033[0m"
  echo -e "\033[2m(${#ANSWERS[@]} answer stored)\033[0m"
}

``
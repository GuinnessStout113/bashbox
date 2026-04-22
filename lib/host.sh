#!/usr/bin/env bash

# Host mode for bashbox

PROMPT="Worst thing to name a production server"
PHASE="COLLECTING_ANSWERS"

PLAYERS=("Guinness")
ANSWERS=()
SHUFFLED_ANSWERS=()
VOTES=()
SCORES=()
``
CSI="\033"
PURPLE="35m"
RESET="0m"
GREEN="32m"
CYAN="36m"
run_host() {
  clear

  echo -e "${CSI}[1;${PURPLE}====================================${CSI}[${RESET}"
  echo -e "${CSI}[1;${PURPLE}        🎉  B A S H B O X  🎉        ${CSI}[${RESET}"
  echo -e "${CSI}[1;${PURPLE}====================================${CSI}[${RESET}"
  echo
  echo -e "${CSI}[1;${GREEN}Host mode started.${CSI}[${RESET}"
  echo -e "Game: ${CSI}[1mQuiplash (prototype)${CSI}[${RESET}"
  echo
  echo -e "${CSI}[1;33mPrompt:${CSI}[${RESET} ${CSI}[1m$PROMPT${CSI}[${RESET}"
  echo
  echo -e "${CSI}[${GREEN}Submit your answer using:${CSI}[${RESET}"
  echo -e "  ${CSI}[1msubmit \"your answer\"${CSI}[${RESET}"
  echo -e "${CSI}[2m(Press Ctrl+C to stop the server)${CSI}[${RESET}"
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
    vote)
      handle_vote "$args"
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

  echo -e "${CSI}[${GREEN}Answer received ✅${CSI}[${RESET}"
  echo -e "${CSI}[2m(${#ANSWERS[@]} answer stored)${CSI}[${RESET}"
  if [[ ${#ANSWERS[@]} -ge 2 ]]; then  
    start_voting
  fi
}

handle_vote() {
  local choice="$1"

  if [[ "$PHASE" != "COLLECTING_VOTES" ]]; then
    echo "Not accepting votes right now."
    return
  fi

  if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
    echo "Usage: vote <number>"
    return
  fi

  if (( choice < 1 || choice > ${#SHUFFLED_ANSWERS[@]} )); then
    echo "Invalid vote number."
    return
  fi

  VOTES+=("$choice")
  echo -e "${CSI}[${GREEN}Vote recorded ✅${CSI}[${RESET}"

  # End round after 1 vote (for now)
  score_round
}

shuffle_array() {
  local i tmp size max rand
  size=${#SHUFFLED_ANSWERS[@]}
  max=$((32768 / size * size))

  for ((i=size-1; i>0; i--)); do
    while (( (rand = RANDOM) >= max )); do :; done
    rand=$((rand % (i+1)))
    tmp=${SHUFFLED_ANSWERS[i]}
    SHUFFLED_ANSWERS[i]=${SHUFFLED_ANSWERS[rand]}
    SHUFFLED_ANSWERS[rand]=$tmp
  done
}

start_voting() {
  PHASE="COLLECTING_VOTES"

  SHUFFLED_ANSWERS=("${ANSWERS[@]}")
  shuffle_array

  echo
  echo -e "${CSI}[1;33mAnswers:${CSI}[${RESET}"

  local i=1
  for ans in "${SHUFFLED_ANSWERS[@]}"; do
    echo -e "  ${CSI}[1m$i)${CSI}[${RESET} $ans"
    ((i++))
  done

  echo
  echo -e "${CSI}[${GREEN}Vote using:${CSI}[${RESET} ${CSI}[1mvote <number>${CSI}[${RESET}"
  echo
}

score_round() {
  PHASE="SCORING"

  echo
  echo -e "${CSI}[1;${PURPLE}Scoring Round...${CSI}[${RESET}"
  sleep 1

  TALLY=()

# Initialize tally with zeros
for ((i=0; i<${#SHUFFLED_ANSWERS[@]}; i++)); do
  TALLY[$i]=0
done

# Count votes
for v in "${VOTES[@]}"; do
  ((TALLY[v-1]++))
done


  echo
  echo -e "${CSI}[1;33mResults:${CSI}[${RESET}"

  local i=1
  for ans in "${SHUFFLED_ANSWERS[@]}"; do
    votes="${TALLY[$((i-1))]}"
    echo -e "  ${CSI}[1m$i)${CSI}[${RESET} $ans — ${CSI}[${GREEN}${votes} vote(s)${CSI}[${RESET}"
    ((i++))
  done

  echo
  echo -e "${CSI}[1;${GREEN}Round complete!${CSI}[${RESET}"
  echo -e "${CSI}[2m(ctrl+c to quit — reset coming next)${CSI}[${RESET}"
}

``
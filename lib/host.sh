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

  echo -e "\033[32mAnswer received ✅\033[0m"
  echo -e "\033[2m(${#ANSWERS[@]} answer stored)\033[0m"
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
  echo -e "\033[32mVote recorded ✅\033[0m"

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
  echo -e "\033[1;33mAnswers:\033[0m"

  local i=1
  for ans in "${SHUFFLED_ANSWERS[@]}"; do
    echo -e "  \033[1m$i)\033[0m $ans"
    ((i++))
  done

  echo
  echo -e "\033[36mVote using:\033[0m \033[1mvote <number>\033[0m"
  echo
}

score_round() {
  PHASE="SCORING"

  echo
  echo -e "\033[1;35mScoring Round...\033[0m"
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
  echo -e "\033[1;33mResults:\033[0m"

  local i=1
  for ans in "${SHUFFLED_ANSWERS[@]}"; do
    votes="${TALLY[$((i-1))]}"
    echo -e "  \033[1m$i)\033[0m $ans — \033[32m${votes} vote(s)\033[0m"
    ((i++))
  done

  echo
  echo -e "\033[1;32mRound complete!\033[0m"
  echo -e "\033[2m(ctrl+c to quit — reset coming next)\033[0m"
}

``
#!/bin/bash

input=$(cat)

# ANSI truecolor palette
CYAN='\033[38;2;97;175;239m'
GREEN='\033[38;2;151;201;195m'
YELLOW='\033[38;2;229;192;123m'
RED='\033[38;2;224;108;117m'
PURPLE='\033[38;2;198;146;233m'
GRAY='\033[38;2;92;99;112m'
RESET='\033[0m'

pct_color() {
    local pct=$1
    if (( $(echo "$pct < 50" | bc -l) )); then echo "$GREEN"
    elif (( $(echo "$pct < 80" | bc -l) )); then echo "$YELLOW"
    else echo "$RED"; fi
}

progress_bar() {
    local pct=$1 width=10
    local filled=$(( pct * width / 100 ))
    (( filled > width )) && filled=$width
    (( filled < 0 )) && filled=0
    local empty=$((width - filled))
    local bar=""
    for ((i=0; i<filled; i++)); do bar="${bar}▰"; done
    for ((i=0; i<empty; i++)); do bar="${bar}▱"; done
    echo "$bar"
}

# --- Session basics ---
model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // "."')
dir_name=$(basename "$cwd")
effort=$(echo "$input" | jq -r '.effort.level // empty')
fast_mode=$(echo "$input" | jq -r '.fast_mode // false')

# --- Context window ---
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
context_int=$(printf "%.0f" "$context_pct")
context_color=$(pct_color "$context_int")
context_bar=$(progress_bar "$context_int")
exceeds_200k=$(echo "$input" | jq -r '.exceeds_200k_tokens // false')

# --- Cost / duration ---
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
cost_fmt=$(printf '$%.2f' "$cost_usd")
duration_sec=$((${duration_ms%.*} / 1000))
duration_min=$((duration_sec / 60))
duration_rem_sec=$((duration_sec % 60))

# --- Git info ---
cd "$cwd" 2>/dev/null || true
git_branch=$(git -c core.commitGraph=false -c gc.auto=0 branch --show-current 2>/dev/null)
git_segment=""
if [ -n "$git_branch" ]; then
    git_stats=$(git -c core.commitGraph=false -c gc.auto=0 diff --shortstat 2>/dev/null)
    added=$(echo "$git_stats" | grep -o '[0-9]* insertion' | grep -o '[0-9]*')
    deleted=$(echo "$git_stats" | grep -o '[0-9]* deletion' | grep -o '[0-9]*')
    [ -z "$added" ] && added="0"
    [ -z "$deleted" ] && deleted="0"
    diff_segment=""
    if [ "$added" != "0" ] || [ "$deleted" != "0" ]; then
        diff_segment=$(printf " ${GREEN}+%s${RESET}${GRAY}/${RESET}${RED}-%s${RESET}" "$added" "$deleted")
    fi
    git_segment=$(printf "${GRAY}│${RESET} 🔀 %s%b" "$git_branch" "$diff_segment")
fi

# --- Pull request badge ---
pr_number=$(echo "$input" | jq -r '.pr.number // empty')
pr_segment=""
if [ -n "$pr_number" ]; then
    pr_url=$(echo "$input" | jq -r '.pr.url // empty')
    pr_state=$(echo "$input" | jq -r '.pr.review_state // empty')
    case "$pr_state" in
        approved) pr_color="$GREEN" ;;
        changes_requested) pr_color="$RED" ;;
        pending) pr_color="$YELLOW" ;;
        *) pr_color="$GRAY" ;;
    esac
    pr_label="#${pr_number}"
    if [ -n "$pr_url" ]; then
        pr_label=$(printf '\e]8;;%s\a#%s\e]8;;\a' "$pr_url" "$pr_number")
    fi
    pr_segment=$(printf "${GRAY}│${RESET} 🔗 ${pr_color}%b${RESET}" "$pr_label")
fi

# --- Model badge extras ---
model_extra=""
[ "$fast_mode" = "true" ] && model_extra="${model_extra} ⚡"
[ -n "$effort" ] && model_extra=$(printf "%s ${PURPLE}🧠 %s${RESET}" "$model_extra" "$effort")

# --- Rate limits (provided directly by Claude Code, no API call needed) ---
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_reset_ts=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_reset_ts=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

format_reset() {
    local ts=$1 fmt=$2
    [ -z "$ts" ] && { echo "--"; return; }
    TZ=Asia/Tokyo LC_TIME=C date -j -f "%s" "${ts%%.*}" "$fmt" 2>/dev/null | tr '[:upper:]' '[:lower:]'
}

# --- Line 1: model, directory, git, PR ---
line1=$(printf "🤖 %s%b ${GRAY}│${RESET} 📁 %s" "$model_name" "$model_extra" "$dir_name")
[ -n "$git_segment" ] && line1="${line1} ${git_segment}"
[ -n "$pr_segment" ] && line1="${line1} ${pr_segment}"
printf '%b\n' "$line1"

# --- Line 2: context usage, cost, duration ---
context_warn=""
[ "$exceeds_200k" = "true" ] && context_warn=" ⚠️"
printf "📊 ${context_color}%s${RESET} ${context_color}%d%%${RESET}%s ${GRAY}│${RESET} 💰 %s ${GRAY}│${RESET} ⏱️  %dm%02ds\n" \
    "$context_bar" "$context_int" "$context_warn" "$cost_fmt" "$duration_min" "$duration_rem_sec"

# --- Line 3/4: rate limits (only shown when Claude Code provides them) ---
if [ -n "$five_hour_pct" ]; then
    five_hour_int=$(printf "%.0f" "$five_hour_pct")
    five_hour_color=$(pct_color "$five_hour_int")
    five_hour_bar=$(progress_bar "$five_hour_int")
    five_hour_reset=$(format_reset "$five_hour_reset_ts" '+%-I%p')
    printf "⏱  5h  ${five_hour_color}%s${RESET}  ${five_hour_color}%d%%${RESET}  ${GRAY}resets %s (Asia/Tokyo)${RESET}\n" \
        "$five_hour_bar" "$five_hour_int" "$five_hour_reset"
fi

if [ -n "$seven_day_pct" ]; then
    seven_day_int=$(printf "%.0f" "$seven_day_pct")
    seven_day_color=$(pct_color "$seven_day_int")
    seven_day_bar=$(progress_bar "$seven_day_int")
    seven_day_reset=$(format_reset "$seven_day_reset_ts" '+%b %-d at %-I%p')
    printf "📅 7d  ${seven_day_color}%s${RESET}  ${seven_day_color}%d%%${RESET}  ${GRAY}resets %s (Asia/Tokyo)${RESET}\n" \
        "$seven_day_bar" "$seven_day_int" "$seven_day_reset"
fi

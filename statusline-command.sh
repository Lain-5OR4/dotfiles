#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Cache configuration
CACHE_FILE="/tmp/claude-usage-cache.json"
CACHE_TTL=360

# ANSI color codes
GREEN='\033[38;2;151;201;195m'
YELLOW='\033[38;2;229;192;123m'
RED='\033[38;2;224;108;117m'
GRAY='\033[38;2;74;88;92m'
RESET='\033[0m'

# Helper function to get color based on percentage
get_color() {
    local pct=$1
    if (( $(echo "$pct < 50" | bc -l) )); then
        echo "$GREEN"
    elif (( $(echo "$pct < 80" | bc -l) )); then
        echo "$YELLOW"
    else
        echo "$RED"
    fi
}

# Helper function to create progress bar
create_progress_bar() {
    local pct=$1
    local filled=$(echo "scale=0; ($pct * 10) / 100" | bc)
    local empty=$((10 - filled))

    local bar=""
    for ((i=0; i<filled; i++)); do
        bar="${bar}▰"
    done
    for ((i=0; i<empty; i++)); do
        bar="${bar}▱"
    done

    echo "$bar"
}

# Function to fetch rate limit data from API
fetch_rate_limits() {
    # Get OAuth token from macOS Keychain
    local token=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)

    if [ -z "$token" ]; then
        echo "{\"five_hour\":{\"utilization\":0},\"seven_day\":{\"utilization\":0}}"
        return
    fi

    # Call Anthropic API
    local response=$(curl -s -H "Authorization: Bearer $token" \
        https://api.anthropic.com/api/oauth/usage)

    if [ $? -eq 0 ] && [ -n "$response" ]; then
        # Cache the response with timestamp
        echo "{\"timestamp\":$(date +%s),\"data\":$response}" > "$CACHE_FILE"
        echo "$response"
    else
        echo "{\"five_hour\":{\"utilization\":0},\"seven_day\":{\"utilization\":0}}"
    fi
}

# Function to get rate limit data (with caching)
get_rate_limits() {
    local now=$(date +%s)

    # Check if cache exists and is valid
    if [ -f "$CACHE_FILE" ]; then
        local cache_time=$(jq -r '.timestamp // 0' "$CACHE_FILE" 2>/dev/null)
        local age=$((now - cache_time))

        if [ $age -lt $CACHE_TTL ]; then
            # Cache is still valid
            jq -r '.data' "$CACHE_FILE" 2>/dev/null
            return
        fi
    fi

    # Cache is invalid or doesn't exist, fetch new data
    fetch_rate_limits
}

# Extract data from input JSON
model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

# Get git info
cwd=$(echo "$input" | jq -r '.workspace.current_dir // "."')
cd "$cwd" 2>/dev/null || true

# Get git branch
git_branch=$(git -c core.commitGraph=false -c gc.auto=0 branch --show-current 2>/dev/null || echo "no-git")

# Get git stats (added/deleted lines)
git_stats=$(git -c core.commitGraph=false -c gc.auto=0 diff --shortstat 2>/dev/null)
if [ -n "$git_stats" ]; then
    added=$(echo "$git_stats" | grep -o '[0-9]* insertion' | grep -o '[0-9]*' || echo "0")
    deleted=$(echo "$git_stats" | grep -o '[0-9]* deletion' | grep -o '[0-9]*' || echo "0")
    [ -z "$added" ] && added="0"
    [ -z "$deleted" ] && deleted="0"
else
    added="0"
    deleted="0"
fi

# Get rate limit data
rate_limits=$(get_rate_limits)
five_hour_pct=$(echo "$rate_limits" | jq -r '.five_hour.utilization // 0')
seven_day_pct=$(echo "$rate_limits" | jq -r '.seven_day.utilization // 0')

# Convert to percentages (API returns 0-1 range)
five_hour_pct=$(echo "$five_hour_pct * 100" | bc -l 2>/dev/null || echo "0")
seven_day_pct=$(echo "$seven_day_pct * 100" | bc -l 2>/dev/null || echo "0")

# Convert percentages to integers for comparison
five_hour_int=$(printf "%.0f" "$five_hour_pct")
seven_day_int=$(printf "%.0f" "$seven_day_pct")
context_int=$(printf "%.0f" "$context_pct")

# Get colors
context_color=$(get_color $context_int)
five_hour_color=$(get_color $five_hour_int)
seven_day_color=$(get_color $seven_day_int)

# Create progress bars
five_hour_bar=$(create_progress_bar $five_hour_int)
seven_day_bar=$(create_progress_bar $seven_day_int)

# Calculate reset times in Asia/Tokyo timezone
# Get reset timestamps from API response
five_hour_reset_ts=$(echo "$rate_limits" | jq -r '.five_hour.expires_at // empty' 2>/dev/null)
seven_day_reset_ts=$(echo "$rate_limits" | jq -r '.seven_day.expires_at // empty' 2>/dev/null)

# Format 5-hour reset time
if [ -n "$five_hour_reset_ts" ]; then
    five_hour_reset=$(TZ=Asia/Tokyo date -j -f "%Y-%m-%dT%H:%M:%S" "${five_hour_reset_ts%%.*}" '+%-I%p' 2>/dev/null | tr '[:upper:]' '[:lower:]')
    [ -z "$five_hour_reset" ] && five_hour_reset="--"
else
    five_hour_reset="--"
fi

# Format 7-day reset time
if [ -n "$seven_day_reset_ts" ]; then
    seven_day_reset=$(TZ=Asia/Tokyo date -j -f "%Y-%m-%dT%H:%M:%S" "${seven_day_reset_ts%%.*}" '+%b %-d at %-I%p' 2>/dev/null | tr '[:upper:]' '[:lower:]')
    [ -z "$seven_day_reset" ] && seven_day_reset="--"
else
    seven_day_reset="--"
fi

# Line 1: Model, Context, Git Stats, Branch
printf "🤖 %s ${GRAY}│${RESET} 📊 ${context_color}%d%%${RESET} ${GRAY}│${RESET} ✏️  ${GREEN}+%s${RESET}${GRAY}/${RESET}${RED}-%s${RESET} ${GRAY}│${RESET} 🔀 %s\n" \
    "$model_name" "$context_int" "$added" "$deleted" "$git_branch"

# Line 2: 5-hour rate limit
printf "⏱  5h  ${five_hour_color}%s${RESET}  ${five_hour_color}%d%%${RESET}  ${GRAY}Resets %s (Asia/Tokyo)${RESET}\n" \
    "$five_hour_bar" "$five_hour_int" "$five_hour_reset"

# Line 3: 7-day rate limit
printf "📅 7d  ${seven_day_color}%s${RESET}  ${seven_day_color}%d%%${RESET}  ${GRAY}Resets %s (Asia/Tokyo)${RESET}\n" \
    "$seven_day_bar" "$seven_day_int" "$seven_day_reset"

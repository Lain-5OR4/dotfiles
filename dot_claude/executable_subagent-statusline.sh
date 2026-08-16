#!/bin/bash

input=$(cat)

GREEN='\033[38;2;151;201;195m'
YELLOW='\033[38;2;229;192;123m'
RED='\033[38;2;224;108;117m'
PURPLE='\033[38;2;198;146;233m'
GRAY='\033[38;2;92;99;112m'
RESET='\033[0m'

columns=$(echo "$input" | jq -r '.columns // 60')
now_ms=$(($(date +%s) * 1000))

model_label() {
    case "$1" in
        *opus-4-8*|*opus*) echo "Opus" ;;
        *sonnet*) echo "Sonnet" ;;
        *haiku*) echo "Haiku" ;;
        *fable*) echo "Fable" ;;
        "") echo "" ;;
        *) echo "$1" ;;
    esac
}

status_icon() {
    case "$1" in
        running|queued|waiting) echo "${YELLOW}●${RESET}" ;;
        completed|done|success) echo "${GREEN}✓${RESET}" ;;
        failed|error) echo "${RED}✗${RESET}" ;;
        blocked|paused) echo "${GRAY}⏸${RESET}" ;;
        cancelled|canceled) echo "${GRAY}⊘${RESET}" ;;
        *) echo "${GRAY}•${RESET}" ;;
    esac
}

sparkline() {
    local samples="$1"
    local n
    n=$(echo "$samples" | jq 'length' 2>/dev/null)
    [ -z "$n" ] || [ "$n" -lt 2 ] 2>/dev/null && return
    local min max
    min=$(echo "$samples" | jq 'min')
    max=$(echo "$samples" | jq 'max')
    local blocks="▁▂▃▄▅▆▇█"
    echo "$samples" | jq -r --arg blocks "$blocks" --argjson min "$min" --argjson max "$max" '
        ($max - $min) as $range
        | .[]
        | if $range == 0 then 4
          else (((. - $min) / $range) * 7 | floor)
          end
        | $blocks[.:.+1]
    ' | tr -d '\n'
}

echo "$input" | jq -c '.tasks[]?' | while IFS= read -r task; do
    id=$(echo "$task" | jq -r '.id')
    name=$(echo "$task" | jq -r '.name // .label // "agent"')
    status=$(echo "$task" | jq -r '.status // "running"')
    model=$(echo "$task" | jq -r '.model // empty')
    effort=$(echo "$task" | jq -r '.effort // empty')
    start=$(echo "$task" | jq -r '.startTime // empty')
    ctx_size=$(echo "$task" | jq -r '.contextWindowSize // empty')
    tok_count=$(echo "$task" | jq -r '.tokenCount // empty')
    samples=$(echo "$task" | jq -c '.tokenSamples // empty')

    icon=$(status_icon "$status")
    mlabel=$(model_label "$model")

    ctx_segment=""
    if [ -n "$ctx_size" ] && [ -n "$tok_count" ] && [ "$ctx_size" != "0" ]; then
        pct=$(( tok_count * 100 / ctx_size ))
        ctx_color="$GREEN"
        [ "$pct" -ge 50 ] && ctx_color="$YELLOW"
        [ "$pct" -ge 80 ] && ctx_color="$RED"
        ctx_segment=" ${GRAY}│${RESET} ${ctx_color}${pct}%${RESET}"
    fi

    spark=""
    if [ -n "$samples" ] && [ "$samples" != "null" ]; then
        spark_raw=$(sparkline "$samples")
        [ -n "$spark_raw" ] && spark=" ${PURPLE}${spark_raw}${RESET}"
    fi

    elapsed=""
    if [ -n "$start" ] && [ "$start" != "null" ]; then
        elapsed_sec=$(( (now_ms - ${start%%.*}) / 1000 ))
        [ "$elapsed_sec" -lt 0 ] && elapsed_sec=0
        elapsed=" ${GRAY}│${RESET} ${elapsed_sec}s"
    fi

    effort_segment=""
    [ -n "$effort" ] && [ "$effort" != "null" ] && effort_segment=" ${PURPLE}🧠${effort}${RESET}"

    model_segment=""
    [ -n "$mlabel" ] && model_segment=" ${GRAY}│${RESET} ${mlabel}${effort_segment}"

    # Budget the name to the available width; fixed segments are short and rarely blow the row.
    overhead=$(( 4 + ${#mlabel} + ${#effort} + 12 ))
    name_budget=$(( columns - overhead ))
    [ "$name_budget" -lt 8 ] && name_budget=8
    if [ "${#name}" -gt "$name_budget" ]; then
        name="${name:0:$((name_budget - 1))}…"
    fi

    content=$(printf '%b %s%b%b%b' "$icon" "$name" "$model_segment" "$ctx_segment" "$spark$elapsed")
    jq -cn --arg id "$id" --arg content "$content" '{id: $id, content: $content}'
done

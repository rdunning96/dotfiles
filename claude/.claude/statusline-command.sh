#!/bin/sh
input=$(cat)
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
basename=$(basename "$dir")
model=$(echo "$input" | jq -r '.model.display_name // ""')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

branch=$(git -C "$dir" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  left="$basename ($branch)"
else
  left="$basename"
fi

if [ -n "$remaining" ]; then
  right="[$model | ctx: $(printf '%.0f' "$remaining")% left]"
else
  right="[$model]"
fi

printf '%s%s%s\n' "$left" "$(printf '%*s' $(( $(tput cols 2>/dev/null || echo 80) - ${#left} - ${#right} )) '')" "$right"

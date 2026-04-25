#!/usr/bin/env bash
# Consolidates per-project Claude memory files into ~/.claude/global-memory/
# Run as a Stop hook so it fires at the end of every session.

GLOBAL_MEM_DIR="$HOME/.claude/global-memory"
PROJECTS_DIR="$HOME/.claude/projects"

mkdir -p "$GLOBAL_MEM_DIR"

TMP_INDEX=$(mktemp)
echo "# Global Memory Index" > "$TMP_INDEX"
echo "" >> "$TMP_INDEX"

# Include files written directly to the global root (new sessions using autoMemoryDirectory)
has_root=false
for mem_file in "$GLOBAL_MEM_DIR"/*.md; do
    [ -f "$mem_file" ] || continue
    filename=$(basename "$mem_file")
    [ "$filename" = "MEMORY.md" ] && continue
    mem_name=$(grep -m1 "^name:" "$mem_file" 2>/dev/null | sed 's/^name: *//')
    mem_desc=$(grep -m1 "^description:" "$mem_file" 2>/dev/null | sed 's/^description: *//')
    [ -z "$mem_name" ] && continue
    if [ "$has_root" = false ]; then
        echo "## Global" >> "$TMP_INDEX"
        has_root=true
    fi
    echo "- [$mem_name]($filename) — $mem_desc" >> "$TMP_INDEX"
done
[ "$has_root" = true ] && echo "" >> "$TMP_INDEX"

# Consolidate from each project's memory directory
for project_dir in "$PROJECTS_DIR"/*/; do
    [ -d "$project_dir" ] || continue
    mem_dir="${project_dir%/}/memory"
    [ -d "$mem_dir" ] || continue

    slug=$(basename "$project_dir")
    dest="$GLOBAL_MEM_DIR/$slug"
    mkdir -p "$dest"

    count=0
    for f in "$mem_dir"/*.md; do
        [ -f "$f" ] || continue
        fn=$(basename "$f")
        [ "$fn" = "MEMORY.md" ] && continue
        cp -f "$f" "$dest/$fn"
        count=$((count + 1))
    done
    label=$(echo "$slug" | sed 's/^-Users-ryandunning-/~\//; s/-/\//g')

    if [ "$count" -eq 0 ] && [ -f "$mem_dir/MEMORY.md" ]; then
        # No individual files — MEMORY.md holds content directly; copy it as a reference
        ref_file="$GLOBAL_MEM_DIR/${slug}.md"
        cp -f "$mem_dir/MEMORY.md" "$ref_file"
        echo "## $label" >> "$TMP_INDEX"
        echo "- [${label} notes](${slug}.md) — project memory (legacy monolithic format)" >> "$TMP_INDEX"
        echo "" >> "$TMP_INDEX"
        continue
    fi

    [ "$count" -eq 0 ] && continue

    if [ -f "$mem_dir/MEMORY.md" ]; then
        echo "## $label" >> "$TMP_INDEX"
        grep "^\- \[" "$mem_dir/MEMORY.md" | sed -E "s|]\(([^)]*)\)|]($slug/\1)|g" >> "$TMP_INDEX"
        echo "" >> "$TMP_INDEX"
    fi
done

mv "$TMP_INDEX" "$GLOBAL_MEM_DIR/MEMORY.md"

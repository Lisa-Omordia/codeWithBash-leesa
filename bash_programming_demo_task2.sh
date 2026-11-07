#!/bin/bash
# Filename: bash_programming_demo_task2.sh

# ============================================
# HELPER FUNCTION
# ============================================
log() {
  echo -e "\n[LOG] $1"
}

# ============================================
# 1. SIMPLE ARRAYS
# ============================================
log "Creating a list of programming languages..."

languages=("REACTJS" "HTML" "CSS" "JQUERY")
languageSort=($(printf "%s\n" "${languages[@]}" | sort))

log "Looping through array (index + value):"
for i in "${!languages[@]}"; do
  echo "[$i] ${languages[$i]}"
done

log "Looping through array to display the 3rd value and it's index:"
for i in "${!languages[@]}"; do
  if [ "$i" -eq 2 ]; then
    echo "[$i] ${languages[$i]}"
  fi
done

# Add new item
languages+=("Figma")
log "After appending: ${languages[@]}"

# ============================================
# 2. TASK 2 - SORTED ARRAY
# ============================================
log "Looping through SORTED language array (index + value):"
for i in "${!languageSort[@]}"; do
  echo "[$i] ${languageSort[$i]}"
done

log "Looping through SORTED language array to display the index of the last value and the last value itself:"
last_index=$((${#languageSort[@]} - 1))
echo "[$last_index] ${languageSort[$last_index]}"

# Alternative one-liner for last value:
# echo "Last value is: ${languageSort[-1]}"

# ============================================
# 3. TASK 2 - UPDATE WITH READ
# ============================================
log "Updating the language array with a new language/tool for frontend development using read"
read -p "Enter a new language/tool for frontend development: " new_tool
languages+=("$new_tool")

# Re-sort after adding
languageSort=($(printf "%s\n" "${languages[@]}" | sort))

log "After updating with read - Original array: ${languages[@]}"
log "After updating with read - SORTED array: ${languageSort[@]}"

echo -e "SETUP\v SUCCESSFULLY\v COMPLETED!!"

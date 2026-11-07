#!/bin/bash
# Filename: bash_programming_demo.sh

# ============================================
# VARIABLES AND STRINGS
# ============================================
str1="USA"
str2="Canada"
num1=10
num2=20

echo "=== STRING COMPARISONS ==="
if [ "$str1" = "$str2" ]; then
  echo "Both countries are the same."
else
  echo "$str1 and $str2 are different countries."
fi

# ============================================
# NUMERIC COMPARISON
# ============================================
echo
echo "=== NUMERIC COMPARISON ==="
if [ $num1 -lt $num2 ]; then
  echo "$num1 is less than $num2"
elif [ $num1 -eq $num2 ]; then
  echo "$num1 equals $num2"
else
  echo "$num1 is greater than $num2"
fi

# ============================================
# READ USER INPUT
# ============================================
echo
read -p "Enter your name: " name
echo "Welcome, $name!"

read -p "Enter your age: " age

if [ $age -ge 18 ]; then
  echo "You are eligible to vote."
else
  echo "You are underage."
fi

echo "Where do you stay ?"
read
# we have not supplied any option or variable
echo "You stay in $REPLY"

echo "Enter firstname: "
read FIRSTNAME
echo "Enter lastname: "
read LASTNAME
NAME="$FIRSTNAME $LASTNAME"
echo "Name is $NAME"

# ============================================
# ARRAYS AND LOOPING
# ============================================
echo
echo "=== ARRAY EXAMPLE ==="
read -p "Enter a few city names (space-separated): " -a cities
echo "You entered ${#cities[@]} cities."
echo "Here they are (using FOR loop):"

for city in "${cities[@]}"; do
  echo "- $city"
done

# ============================================
# WHILE LOOP
# ============================================
echo
echo "=== WHILE LOOP ==="
counter=1
while [ $counter -le 5 ]; do
  echo "Counter: $counter"
  ((counter++))  # arithmetic increment
done

# ============================================
# UNTIL LOOP
# ============================================
echo
echo "=== UNTIL LOOP ==="
num=0
until [ $num -gt 3 ]; do
  echo "Number is $num"
  ((num++))
done

# ============================================
# CASE / SWITCH STATEMENT
# ============================================
echo
echo "=== CASE / SWITCH DEMO ==="
read -p "Enter your favorite programming language: " lang

case $lang in
  "bash" | "Bash")
    echo "You're a shell wizard! 🧙"
    ;;
  "python" | "Python")
    echo "You love readability and indentation!"
    ;;
  "java" | "Java")
    echo "You like strong typing and OOP!"
    ;;
  "c" | "C")
    echo "You're close to the metal!"
    ;;
  *)
    echo "Interesting choice: $lang"
    ;;
esac

# ============================================
# FUNCTION
# ============================================
echo
echo "=== FUNCTION EXAMPLE ==="
greet_user() {
  local person=$1
  echo "Hello, $person! Nice to meet you."
}

greet_user "$name"

# ============================================
# COMMAND-LINE ARGUMENTS
# ============================================
echo
echo "=== COMMAND-LINE ARGUMENTS ==="
cat << ARGS
Script name: $0
1st argument: $1
2nd argument: $2
Total number of arguments: $#
ARGS

# ============================================
# EXIT STATUS DEMO
# ============================================
echo
echo "=== EXIT STATUS ==="
[ $num1 -eq $num2 ]
echo "Exit code of comparison (0 = true, 1 = false): $?"

echo -e "SETUP\v SUCCESSFULLY\v COMPLETED!!"
exit 0

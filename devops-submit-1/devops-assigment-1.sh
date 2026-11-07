

Create a directory named `$USER-bash1` in `~/Documents`. Inside it do the following:

1. Type this command:
ps aux | awk '{print $6/1024 " MB\t\t" $11}' | sort -n >  $USER-mem.txt

    a. Notice the header below, what does VSZ and RSS mean in the header?
    USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND

    b. Print on your console the 5 biggest memory processes in descending order


2. Refer to the `psaux.txt` file:
    a. Print ONLY the unique USER processes on your console (hint! `awk`, `sort`, `uniq`) 
    b. How many unique USER processes are there? (hint! `awk`, `sort`, `uniq`, `wc`)


3. Learn these concepts:

# | Concept    | Bash Example       | Equivalent In             |
# | ---------- | ------------------ | ------------------------- |
# | If/Else    | `[ $a -lt $b ]`    | Python / C `if`           |
# | For Loop   | `for city in ...`  | Python `for item in list` |
# | While Loop | `while [ cond ]`   | C-style while             |
# | Until Loop | `until [ cond ]`   | do/while in C             |
# | Switch     | `case ... esac`    | `switch` in C/Java        |
# | Function   | `myfunc() { ... }` | Def function              |
# | Arguments  | `$0 $1 $2 $#`      | sys.argv / argv[]         |

Using nano editor, create `bash_prog_demo.sh`, copy below script into it, 
give it executable permissions and run it to learn the concepts above:

Optional: You can create `bash_prog_demo_v1.sh` and experiment with these concepts.

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



4. A very simple exercise! 
   The script below has been provided for you. 
# ============================================
Using nano editor, create `bash_programming_demo_task2.sh`, edit to accomplish the following:

log "Looping through `SORTED` language array (index + value):"
log "Looping through `SORTED` language array to display the index of the last value and the last value itself:"
Updating the language array with a new language/tool for frontend development using `read` 
# ============================================



#!/bin/bash
# Filename: bash_programming_demo_task1.sh
# ============================================
# HELPER FUNCTION
# ============================================
log() {
  echo -e "\n[LOG] $1"
}

# ============================================
# 1️⃣ SIMPLE ARRAYS
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
  if [ "$i" -et 2 ]; then
    echo "[$i] ${languages[$i]}"
  fi
done

# Add new item
languages+=("Figma")
log "After appending: ${languages[@]}"

echo -e "SETUP\v SUCCESSFULLY\v COMPLETED!!"



5. PUSH YOUR WORK TO GITHUB using SSH.

a. Create a public repo on github named codeWithBash-$USER i.e codeWithBash-izu or codeWithBash-chichi etc

b. Still inside `$USER-bash1` in `~/Documents` follow the instructions on the empty repo on github and push your work
   
   NB. When adding the url, choose the one without https( Hint! It's the one with ssh://). 
   This means you should create a ed25519 ssh key on your laptop in ~/.ssh and 
   cat the public key and add it to your github account.

   Be advised that if your laptop's public ssh key is not in your github ssh key settings, 
   you won't be able to push, pull or clone.

c. send me the link to your repo 


6. Install nginx from source on your laptop because the version in the ubuntu repo is not the latest.
    
    So visit https://nginx.org. Notice the stable release. 
    Click on 2026-10-14	"nginx-1.30.6" stable..
    And you will see nginx-1.30.6 pgp.
    Click on the link nginx-1.30.6 to download the tar.gz file [https://nginx.org/download/nginx-1.30.6.tar.gz]

  Check nginx-install.sh. The version must match with the one you downloaded.
  If not, edit the script (in line 7) to match the version you downloaded. 
  
  Then run it as root.
    chmod +x nginx-install.sh
    sudo bash nginx-install.sh
  
  # NB: The script is able to install nginx you downloaded that is present 
  # in the same directory as the script. If not, it will download it from the nginx.org website.

7. If your install was successful, a visit to http://localhost or http://127.0.0.1 on your browser 
should show default nginx webpage.

8. I have provided a folder named `deploywebapp`. It's a simple html, css resume project.

    Then move it to `/home/$USER/Documents/$USER-bash1/` directory. 
    So the complete path should be: /home/$USER/Documents/$USER-bash1/deploywebapp 
    when you type `pwd` inside the deploywebapp folder.

9. Now `cd` to `/etc/nginx/sites-available` and type:
   sudo nano default 
use your up and down arrow keys to scroll down to root block and you will see:
   root /var/www/html;
   
   and replace it with the full path to your deploywebapp folder which should be:
   root /home/$USER/Documents/$USER-bash1/deploywebapp;

Exit the document with Ctrlx, then y, then enter to save.

type:
sudo systemctl restart nginx

Go to your browser, refresh or type http://localhost or http://127.0.0.1 on a new tab 
and you should see your resume project.

Paste your screenshot of the home page.

If you can't see your resume project, check the following:
- Check if nginx is running: sudo systemctl status nginx
- Check if the root path in /etc/nginx/sites-available/default is correct

# Check access and errors in the log files below:
- sudo tail -f /var/log/nginx/error.log 
- sudo tail -f /var/log/nginx/access.log




Optional: Attempt installation of ngrok via: https://ngrok.com/download/linux?tab=download

Sign up to get your `token`, then add it:
    ngrok config add-authtoken <token>

Start an endpoint:
ngrok http 80

As long as it's running live on your laptop, you can send me the endpoint so I'll check if the application you hosted is live!



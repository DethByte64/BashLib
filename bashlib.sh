# Author: DethByte64
# Title: BashLib
# Description: BashLib is a Bash Source file that
# contains many different functions that can be used
# in various ways some of these are for strings,
# numbers, randoms and networking. There are a total
# of 44 functions. For a full list of functions, source
# the file with ". bashlib.sh" then execute "bashlib.list"

  ### Strings ###

function bashlib.str.encrypt() {
if [ ! $1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: ${FUNCNAME[0]} -f|-s [<file>|[string]] [passphrase]"
  echo "Encrypts a string or file with given passphrase"
else
  while [ $# -gt 0 ]; do
    case $1 in
      -f)
        type=file
        shift
        file=$1
        pass=$2
        break
        ;;
      -s)
        type=string
        shift
        string=$1
        pass=$2
        break
        ;;
      *)
        bashlib.str.encrypt -h
        exit 1
        ;;
    esac
    shift
  done
  if [ "$type" = "file" ]; then
    output=$(cat $file | openssl enc -e --aes-256-cbc -base64 -nosalt -k $pass 2>/dev/null)
  else
    output=$(echo "$string" | openssl enc -e --aes-256-cbc -base64 -nosalt -k $pass 2>/dev/null)
  fi
  echo "$output"
fi
}

function bashlib.str.decrypt() {
if [ ! $1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: ${FUNCNAME[0]} -f|-s [<file>|[string]] [passphrase]"
  echo "Decrypts a string or file with given passphrase" 
else
  while [ $# -gt 0 ]; do
    case $1 in
      -f)
        type=file
        shift
        file=$1
        pass=$2
        break
        ;;
      -s)
        type=string
        shift
        string=$1
        pass=$2
        break
        ;;
      *)
        bashlib.str.decrypt -h
        exit 1
        ;;
    esac
    shift
  done
  if [ "$type" = "file" ]; then
    output=$(cat $file | openssl enc -d --aes-256-cbc -base64 -nosalt -k $pass 2>/dev/null)
  else
    output=$(echo "$string" | openssl enc -d --aes-256-cbc -base64 -nosalt -k $pass 2>/dev/null)
  fi
  echo "$output"
fi
}

function bashlib.str.getPos() {
if [ ! $1 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: ${FUNCNAME[0]} [string] <n>"
  echo "Prints the corresponding letter to a given number"
else
  local string=$1
  local num=$2
  echo "${string:$num:1}"
fi
}

function bashlib.str.getLen() {
if [ ! $1 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: ${FUNCNAME[0]} [string]"
  echo "Prints the length of a given string"
else
  local string=$1
  echo "${#string}"
fi
}

function bashlib.str.getConfig() {
if [ ! $1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: ${FUNCNAME[0]} [key] <configfile>"
  echo "Gets value of a key in a config file"
else
  local key="$1"
  local file="$2"
  config=$(grep "$key=" "$file")
  value=${config##*=}
  echo "$value"
fi
}

function bashlib.str.setConfig() {
if [ ! $1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: ${FUNCNAME[0]} [key] [value] <configfile>"
  echo "Sets a config option in a specified file"
else
  local key="$1"
  local val="$2"
  local file="$3"
  for line in $(cat $file); do
    if [ $(echo "$line" | grep "$key") ]; then
      oldval=$(echo "$line" | cut -d'=' -f2)
      echo "${line/$oldval/$val}"
      echo "${line/$oldval/$val}" >> tmpconfig
    else
      echo $line
      echo "$line" >> tmpconfig
    fi
  done
  cat tmpconfig > $file && rm tmpconfig
fi
}

  ### Cursors ###

function bashlib.cursor.setPos() {
if [ ! $1 ] || [ "$1" = "-h" ] || [ "$1" = "--hello" ]; then
  echo "Usage: ${FUNCNAME[0]} <line> <column>"
  echo "Sets the cursor position"
else
  echo -en "\033[${1};${2}f"
fi
}
function bashlib.cursor.getPos() {
exec < /dev/tty
oldstty=$(stty -g)
stty raw -echo min 0
echo -en "\033[6n" > /dev/tty
IFS=' ' read -r -d R -a pos
stty $oldstty
#line=$pos[0]
#col=$pos[1]
line=$(($(echo "${pos[0]:2}" |cut -d';' -f1) - 1))
col=$(echo "$pos[1]"|cut -d';' -f2 | cut -d'[' -f1)

echo -n "$line $col"
}
function bashlib.cursor.up() { echo -en "\033[${1}A"; }
function bashlib.cursor.down() { echo -en "\033[${1}B"; }
function bashlib.cursor.right() { echo -en "\033[${1}C"; }
function bashlib.cursor.left() { echo -en "\033[${1}D"; }
function bashlib.cursor.backspace() { echo -en "\b"; }

  ### Style ###
function bashlib.style.none() { echo -en "\033[0m"; }
function bashlib.style.bold() { echo -en "\033[1m"; }
function bashlib.style.dim() { echo -en "\033[2m"; }
function bashlib.style.italic() { echo -en "\033[3m"; }
function bashlib.style.underline() { echo -en "\033[4m"; }
function bashlib.style.invert() { echo -en "\033[7m"; }
function bashlib.style.hide() { echo -en "\033[8m"; }
function bashlib.style.strike() { echo -en "\033[9m"; }

  ### Color ###

function bashlib.fgcolor.red() { echo -en "\033[91m"; }
function bashlib.fgcolor.yellow() { echo -en "\033[93m"; }
function bashlib.fgcolor.green() { echo -en "\033[92m"; }
function bashlib.fgcolor.blue() { echo -en "\033[94m"; }
function bashlib.fgcolor.purple() { echo -en "\033[95m"; }
function bashlib.fgcolor.gray() { echo -en "\033[90m"; }
function bashlib.fgcolor.white() { echo -en "\033[97m"; }
function bashlib.bgcolor.red() { echo -en "\033[101m"; }
function bashlib.bgcolor.yellow() { echo -en "\033[103m"; }
function bashlib.bgcolor.green() { echo -en "\033[102m"; }
function bashlib.bgcolor.blue() { echo -en "\033[104m"; }
function bashlib.bgcolor.purple() { echo -en "\033[105m"; }
function bashlib.bgcolor.gray() { echo -en "\033[100m"; }
function bashlib.bgcolor.white() { echo -en "\033[107m"; }


  ### Rands ###

function bashlib.rand() {
if [ $1 ]; then
  echo "Usage: ${FUNCNAME[0]}"
  echo "Prints a random number"
else
 echo $RANDOM
fi
}
function bashlib.rand.range() {
if [ ! $2 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: ${FUNCNAME[0]} <n1> <n2>"
  echo "Generates a number between <n1> and <n2>"
else
  local num1=$1
  local num2=$2
  echo $(($RANDOM % $num2 + $num1))
fi
}

function bashlib.rand.str() {
if [[ "$1" = *[a-zA-Z]* ]] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: ${FUNCNAME[0]} <n>"
  echo "Prints a random string. Default length is 32"
  echo "Length can be given as an argument."
else
  cat /dev/urandom | tr -dc "a-zA-Z0-9" | head -c ${1:-32}
fi
}

  ### Net ###

function bashlib.net.connect() {
if [ ! $3 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: ${FUNCNAME[0]} [tcp|udp] [host] <port>"
  echo "Creates a network connection and returns a file descriptor"
else
  local proto=$1
  local host=$2
  local port=$3
  for ((fd=3; fd<254; fd++)); do
    if { ! eval "echo '' >& $fd 2>/dev/null"; } 2>/dev/null; then
      eval "exec $fd<>/dev/$proto/$host/$port"
      echo "$fd"
      break
    fi
  done
fi
}

function bashlib.net.close() {
if [ ! $1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: ${FUNCNAME[0]} <fd>"
  echo "Closes an open network connection"
else
  local myfd=$1
  eval "exec $myfd>&-"
fi
}

function bashlib.net.send() {
if [ ! $2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: ${FUNCNAME[0]} <fd> data"
  echo "Sends data to an open connection but data must be enclosed in double quotes" 
else
  local myfd=$1
  local data=$2
  echo "$data" >& "$myfd"
fi
}

function bashlib.net.read() {
if [ ! $1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: ${FUNCNAME[0]} <fd>"
  echo "Reads data from an open connection"
else
  local myfd=$1
  read data <& "$myfd"
  echo "$data"
fi
}

function bashlib.net.portscan() {
if [ ! $1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: ${FUNCNAME[0]} [tcp|udp] [host] <port>"
  echo "Scans Port of target host"
else
  host="$2"
  proto="${1:-tcp}"
  port="$3"
  function scan() {
    bash -c "echo > /dev/$1/$2/$3" &>/dev/null &
    pid=$!
    {
      sleep 1
      kill -9 $pid &>/dev/null &
    } &
    wait $pid &>/dev/null
    return $?
  }
  (scan $proto $host $port)
  if [ $? = 0 ]; then
    echo "$host:$port open"
  else
    echo "$host:$port closed"
  fi
fi
}

function bashlib.list() {
  fns=$(grep 'bashlib.*)' bashlib.lib | cut -d' ' -f2 | cut -d'(' -f1 | head -n -1)
  echo "$fns"
}

#!/bin/bash
# Author: DethByte64
# Title: BashLib
# Description: BashLib is a Bash Source file that
# contains many different functions that can be used
# in various ways some of these are for strings,
# numbers, randoms and networking. There are a total
# of 44 functions. For a full list of functions, source
# the file with ". bashlib.sh" then execute "bashlib.list"

checkargs() {
  case "$1" in
    ''|-h|--help)
      shift
      echo -e "$@"
      exit 1
      ;;
    *)
      return 0
      ;;
  esac
  return 0
}

  ### Strings ###

bashlib.str.encrypt() {
checkargs "$1" "Usage: ${FUNCNAME[0]} -f|-s [<file>|[string]] [passphrase]\nEncrypts a string or file with given passphrase"
  while [ $# -gt 0 ]; do
    case $1 in
      -f)
        type="file"
        shift
        file="$1"
        pass="$2"
        break
        ;;
      -s)
        type="string"
        shift
        string="$1"
        pass="$2"
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
    output=$(openssl enc -e --aes-256-cbc -base64 -nosalt -k "$pass" 2>/dev/null < "$file")
  else
    output=$(echo "$string" | openssl enc -e --aes-256-cbc -base64 -nosalt -k "$pass" 2>/dev/null)
  fi
  echo "$output"
}

bashlib.str.decrypt() {
checkargs "$1" "Usage: ${FUNCNAME[0]} -f|-s [<file>|[string]] [passphrase]\nDecrypts a string or file with given passphrase"
  while [ $# -gt 0 ]; do
    case $1 in
      -f)
        type="file"
        shift
        file="$1"
        pass="$2"
        break
        ;;
      -s)
        type="string"
        shift
        string="$1"
        pass="$2"
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
    output=$(openssl enc -d --aes-256-cbc -base64 -nosalt -k "$pass" 2>/dev/null < "$file")
  else
    output=$(echo "$string" | openssl enc -d --aes-256-cbc -base64 -nosalt -k "$pass" 2>/dev/null)
  fi
  echo "$output"
}

bashlib.str.getPos() {
  checkargs "$1" "Usage: ${FUNCNAME[0]} [string] <n>\nPrints the corresponding letter to a given number"
  local string="$1"
  local num="$2"
  echo "${string:$num:1}"
}

bashlib.str.getLen() {
  checkargs "$1" "Usage: ${FUNCNAME[0]} [string]\nPrints the length of a given string"
  local string="$1"
  echo "${#string}"
}

bashlib.str.getConfig() {
checkargs "$1" "Usage: ${FUNCNAME[0]} [key] <configfile>\nGets value of a key in a config file"
  local key="$1"
  local file="$2"
  config=$(grep "$key=" "$file")
  value="${config##*=}"
  echo "$value"
}

bashlib.str.setConfig() {
checkargs "$1" "Usage: ${FUNCNAME[0]} [key] [value] <configfile>\nSets a config option in a specified file"
  local key="$1"
  local val="$2"
  local file="$3"
  while read -r line; do
    if [ "$(echo "$line" | grep -q "$key")" ]; then
      oldval="$(echo "$line" | cut -d'=' -f2)"
      echo "${line/$oldval/$val}"
      echo "${line/$oldval/$val}" >> tmpconfig
    else
      echo "$line"
      echo "$line" >> tmpconfig
    fi
  done < "$file"
  cat tmpconfig > "$file" && rm tmpconfig
}

  ### Cursors ###

bashlib.cursor.setPos() {
checkargs "$1" "Usage: ${FUNCNAME[0]} <line> <column>\nSets the cursor position"
  echo -en "\033[${1};${2}f"
}

bashlib.cursor.getPos() {
  exec < /dev/tty
  oldstty="$(stty -g)"
  stty raw -echo min 0
  echo -en "\033[6n" > /dev/tty
  IFS=' ' read -r -d R -a pos
  stty "$oldstty"
  line=$(($(echo "${pos[0]:2}" |cut -d';' -f1) - 1))
  col=$(echo "${pos[1]}"|cut -d';' -f2 | cut -d'[' -f1)
  echo -n "$line $col"
}

bashlib.cursor.up() { echo -en "\033[${1}A"; }
bashlib.cursor.down() { echo -en "\033[${1}B"; }
bashlib.cursor.right() { echo -en "\033[${1}C"; }
bashlib.cursor.left() { echo -en "\033[${1}D"; }
bashlib.cursor.backspace() { echo -en "\b"; }

  ### Style ###
bashlib.style.none() { echo -en "\033[0m"; }
bashlib.style.bold() { echo -en "\033[1m"; }
bashlib.style.dim() { echo -en "\033[2m"; }
bashlib.style.italic() { echo -en "\033[3m"; }
bashlib.style.underline() { echo -en "\033[4m"; }
bashlib.style.invert() { echo -en "\033[7m"; }
bashlib.style.hide() { echo -en "\033[8m"; }
bashlib.style.strike() { echo -en "\033[9m"; }

  ### Color ###

bashlib.fgcolor.red() { echo -en "\033[91m"; }
bashlib.fgcolor.yellow() { echo -en "\033[93m"; }
bashlib.fgcolor.green() { echo -en "\033[92m"; }
bashlib.fgcolor.blue() { echo -en "\033[94m"; }
bashlib.fgcolor.purple() { echo -en "\033[95m"; }
bashlib.fgcolor.gray() { echo -en "\033[90m"; }
bashlib.fgcolor.white() { echo -en "\033[97m"; }
bashlib.bgcolor.red() { echo -en "\033[101m"; }
bashlib.bgcolor.yellow() { echo -en "\033[103m"; }
bashlib.bgcolor.green() { echo -en "\033[102m"; }
bashlib.bgcolor.blue() { echo -en "\033[104m"; }
bashlib.bgcolor.purple() { echo -en "\033[105m"; }
bashlib.bgcolor.gray() { echo -en "\033[100m"; }
bashlib.bgcolor.white() { echo -en "\033[107m"; }


  ### Rands ###

bashlib.rand() { echo "$RANDOM"; }

bashlib.rand.range() {
checkargs "$1" "Usage: ${FUNCNAME[0]} <n1> <n2>\nGenerates a number between <n1> and <n2>"
  local num1="$1"
  local num2="$2"
  echo "$((RANDOM % num2 + num1))"
}

bashlib.rand.str() {
[[ "$1" = *[a-zA-Z]* ]] && checkargs "$1" "Usage: ${FUNCNAME[0]} <n>\nPrints a random string. Default length is 32\nLength can be given as an argument." && tr -dc "a-zA-Z0-9" </dev/urandom | head -c "${1:-32}"
}

  ### Net ###

bashlib.net.connect() {
checkargs "$1" "Usage: ${FUNCNAME[0]} [tcp|udp] [host] <port>\nCreates a network connection and returns a file descriptor"
  local proto="$1"
  local host="$2"
  local port="$3"
  for ((fd=3; fd<254; fd++)); do
    if { ! eval "echo '' >& $fd 2>/dev/null"; } 2>/dev/null; then
      eval "exec $fd<>/dev/$proto/$host/$port"
      echo "$fd"
      break
    fi
  done
}

bashlib.net.close() {
checkargs "$1" "Usage: ${FUNCNAME[0]} <fd>\nCloses an open network connection"
  local myfd="$1"
  eval "exec $myfd>&-"
}

bashlib.net.send() {
checkargs "$1" "Usage: ${FUNCNAME[0]} <fd> data\nSends data to an open connection but data must be enclosed in double quotes"
  local myfd="$1"
  local data="$2"
  echo "$data" >& "$myfd"
}

bashlib.net.read() {
checkargs "$1" "Usage: ${FUNCNAME[0]} <fd>\nReads data from an open connection"
  local myfd="$1"
  read -r data <& "$myfd"
  echo "$data"
}

bashlib.net.portscan() {
checkargs "$1" "Usage: ${FUNCNAME[0]} [tcp|udp] [host] <port>\nScans Port of target host"
  host="$2"
  proto="$1"
  port="$3"
  scan() {
    bash -c "echo > /dev/$1/$2/$3" &>/dev/null &
    pid=$!
    {
      sleep 1
      kill -9 $pid &>/dev/null &
    } &
    wait $pid &>/dev/null
    return $?
  }
  if (scan "$proto" "$host" "$port"); then
    echo "$host:$port open"
  else
    echo "$host:$port closed"
  fi
}

bashlib.list() {
  fns=$(grep 'bashlib.*)' bashlib.lib | cut -d' ' -f2 | cut -d'(' -f1 | head -n -1)
  echo "$fns"
}

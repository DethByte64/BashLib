#!/bin/bash
# Author: DethByte64
# Title: BashLib
# Description: BashLib is a Bash Source file that
# contains many different functions that can be used
# in various ways some of these are for strings,
# numbers, randoms and networking. There are a total
# of 47 functions. For a full list of functions, source
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
  local tmp=".tmpconf"
  local change=0
  local oldval=""
  local only_key=""
  if [ ! -f "$tmp" ]; then
    touch "$tmp"
  fi
  if [ ! -f "$file" ]; then
    touch "$file"
  fi
  while read -r line; do
    only_key="$(echo "$line" | cut -d'=' -f1)"
    if [ "$only_key" = "$key" ]; then
      oldval="$(echo "$line" | cut -d'=' -f2)"
      echo "${line//$oldval/$val}" >> "$tmp"
      change=1
    else
      echo "$line" >> "$tmp"
    fi
  done < "$file"
  if [ "$change" = "0" ]; then
    echo "$key=$val" >> "$tmp"
  fi
  cat "$tmp" > "$file" && rm "$tmp"
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
  line="$(($(echo "${pos[0]:2}" |cut -d';' -f1) - 1))"
  # shellcheck disable=SC2128
  col="$(echo "${pos}[1]"|cut -d';' -f2 | cut -d'[' -f1)"
  echo "$line $col"
}

bashlib.cursor.hide() { echo -en "\033[?25l"; }
bashlib.cursor.show() { echo -en "\033[?25h"; }
bashlib.cursor.up() { echo -en "\033[${1}A"; }
bashlib.cursor.down() { echo -en "\033[${1}B"; }
bashlib.cursor.right() { echo -en "\033[${1}C"; }
bashlib.cursor.left() { echo -en "\033[${1}D"; }
bashlib.cursor.backspace() { echo -en "\b"; }

  ### Input ###
bashlib.input.listen() {
#  checkargs "" "Usage: ${FUNCNAME[0]}\nStarts an interactive key listener that calls on_* functions"

  local key
  local esc
  _bashlib_listener="go"
  while [ "$_bashlib_listener" != "stop" ]; do
    declare -F pre_input_hook >/dev/null && pre_input_hook
    # Read one character
    IFS='' read -rsn1 key
    case "$key" in
      '') declare -F on_enter >/dev/null && on_enter ;;
      ' ') declare -F on_space >/dev/null && on_space ;;
      0) declare -F on_0 >/dev/null && on_0 ;;
      1) declare -F on_1 >/dev/null && on_1 ;;
      2) declare -F on_2 >/dev/null && on_2 ;;
      3) declare -F on_3 >/dev/null && on_3 ;;
      4) declare -F on_4 >/dev/null && on_4 ;;
      5) declare -F on_5 >/dev/null && on_5 ;;
      6) declare -F on_6 >/dev/null && on_6 ;;
      7) declare -F on_7 >/dev/null && on_7 ;;
      8) declare -F on_8 >/dev/null && on_8 ;;
      9) declare -F on_9 >/dev/null && on_9 ;;
      A) declare -F on_A >/dev/null && on_A ;;
      B) declare -F on_B >/dev/null && on_B ;;
      C) declare -F on_C >/dev/null && on_C ;;
      D) declare -F on_D >/dev/null && on_D ;;
      E) declare -F on_E >/dev/null && on_E ;;
      F) declare -F on_F >/dev/null && on_F ;;
      G) declare -F on_G >/dev/null && on_G ;;
      H) declare -F on_H >/dev/null && on_H ;;
      I) declare -F on_I >/dev/null && on_I ;;
      J) declare -F on_J >/dev/null && on_J ;;
      K) declare -F on_K >/dev/null && on_K ;;
      L) declare -F on_L >/dev/null && on_L ;;
      M) declare -F on_M >/dev/null && on_M ;;
      N) declare -F on_N >/dev/null && on_N ;;
      O) declare -F on_O >/dev/null && on_O ;;
      P) declare -F on_P >/dev/null && on_P ;;
      Q) declare -F on_Q >/dev/null && on_Q ;;
      R) declare -F on_R >/dev/null && on_R ;;
      S) declare -F on_S >/dev/null && on_S ;;
      T) declare -F on_T >/dev/null && on_T ;;
      U) declare -F on_U >/dev/null && on_U ;;
      V) declare -F on_V >/dev/null && on_V ;;
      W) declare -F on_W >/dev/null && on_W ;;
      X) declare -F on_X >/dev/null && on_X ;;
      Y) declare -F on_Y >/dev/null && on_Y ;;
      Z) declare -F on_Z >/dev/null && on_Z ;;
      a) declare -F on_a >/dev/null && on_a ;;
      b) declare -F on_b >/dev/null && on_b ;;
      c) declare -F on_c >/dev/null && on_c ;;
      d) declare -F on_d >/dev/null && on_d ;;
      e) declare -F on_e >/dev/null && on_e ;;
      f) declare -F on_f >/dev/null && on_f ;;
      g) declare -F on_g >/dev/null && on_g ;;
      h) declare -F on_h >/dev/null && on_h ;;
      i) declare -F on_i >/dev/null && on_i ;;
      j) declare -F on_j >/dev/null && on_j ;;
      k) declare -F on_k >/dev/null && on_k ;;
      l) declare -F on_l >/dev/null && on_l ;;
      m) declare -F on_m >/dev/null && on_m ;;
      n) declare -F on_n >/dev/null && on_n ;;
      o) declare -F on_o >/dev/null && on_o ;;
      p) declare -F on_p >/dev/null && on_p ;;
      q) declare -F on_q >/dev/null && on_q ;;
      r) declare -F on_r >/dev/null && on_r ;;
      s) declare -F on_s >/dev/null && on_s ;;
      t) declare -F on_t >/dev/null && on_t ;;
      u) declare -F on_u >/dev/null && on_u ;;
      v) declare -F on_v >/dev/null && on_v ;;
      w) declare -F on_w >/dev/null && on_w ;;
      x) declare -F on_x >/dev/null && on_x ;;
      y) declare -F on_y >/dev/null && on_y ;;
      z) declare -F on_z >/dev/null && on_z ;;
      *)  # Escape sequence (Arrow keys)
        # Read the next two characters of the escape sequence
        read -rsn2 key || continue
        case "$key" in
          '[A') declare -F on_up    >/dev/null && on_up    ;;
          '[B') declare -F on_down  >/dev/null && on_down  ;;
          '[C') declare -F on_right >/dev/null && on_right ;;
          '[D') declare -F on_left  >/dev/null && on_left  ;;
        esac
      ;;
    esac
    declare -F post_input_hook >/dev/null && post_input_hook
  done
}

bashlib.input.stop() {
_bashlib_listener="stop"
}

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

  ### Math ###

bashlib.math() {
  awk "BEGIN { print $*}"
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
  fns=$(grep 'bashlib.*)' bashlib.sh | cut -d' ' -f1 | cut -d'(' -f1 | head -n -1)
  echo "$fns"
}

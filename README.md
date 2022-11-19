# BashLib
A Bash Source file that contains many useful functions.

BashLib is a Bash Source file that
contains many different functions that can be used
in various ways some of these are for strings, cursor movements, 
numbers, randoms and networking. There are a total
of 47 functions. For a full list of functions, Run this command.
```bash
. bashlib.sh && bashlib.list
```

# Functions and definitions
## Strings and Files
* bashlib.str.encrypt
* bashlib.str.decrypt
* bashlib.str.getPos
* bashlib.str.getLen
* bashlib.str.getConfig
* bashlib.str.setConfig

## Cursor Styles and Movements
### Cursor Movements and Helpers
* bashlib.cursor.setPos
* bashlib.cursor.getPos
* bashlib.cursor.hide
* bashlib.cursor.show
* bashlib.cursor.up
* bashlib.cursor.down
* bashlib.cursor.right
* bashlib.cursor.left
* bashlib.cursor.backspace
### Styling
* bashlib.style.none
* bashlib.style.bold
* bashlib.style.dim
* bashlib.style.italic
* bashlib.style.underline
* bashlib.style.invert
* bashlib.style.hide
* bashlib.style.strike
### Text Colors
* bashlib.fgcolor.red
* bashlib.fgcolor.yellow
* bashlib.fgcolor.green
* bashlib.fgcolor.blue
* bashlib.fgcolor.purple
* bashlib.fgcolor.gray
* bashlib.fgcolor.white
### Background Colors
* bashlib.bgcolor.red
* bashlib.bgcolor.yellow
* bashlib.bgcolor.green
* bashlib.bgcolor.blue
* bashlib.bgcolor.purple
* bashlib.bgcolor.gray
* bashlib.bgcolor.white

## Numbers
* bashlib.rand
* bashlib.rand.range
* bashlib.rand.str
* bashlib.math

## Networking
* bashlib.net.connect
* bashlib.net.close
* bashlib.net.send
* bashlib.net.read
* bashlib.net.portscan

## Listing Functions of BashLib
* bashlib.list

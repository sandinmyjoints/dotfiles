# This file is only meant to be sourced, not run.
called=$_
if [[ $called != $0 ]] ; then
    echo "${BASH_SOURCE[@]} is being sourced."
else
    this_file=`basename "$0"`
    echo "WARNING: $this_file is being run. It is only meant to be sourced."
fi

# Constants and functions for terminal colors.
# Author: Max Tsepkov <max@yogi.pw>
#
# Adapted from https://github.com/maxtsepkov/bash_colors
#
# List of colors: http://misc.flogisoft.com/bash/tip_colors_and_formatting

# Escape code is 033 octal.
CLR_ESC="\033["

# All these varibles has a function with the same name, but in lower case.
#
CLR_RESET=0             # reset all attributes to their defaults
CLR_RESET_UNDERLINE=24  # underline off
CLR_RESET_REVERSE=27    # reverse off
CLR_DEFAULT=39          # set underscore off, set default foreground color
CLR_DEFAULTB=49         # set default background color

CLR_BOLD=1              # set bold
CLR_BRIGHT=2            # set half-bright (simulated with color on a color display)
CLR_UNDERSCORE=4        # set underscore (simulated with color on a color display)
CLR_REVERSE=7           # set reverse video

CLR_BLACK=30            # set black foreground
CLR_RED=31              # set red foreground
CLR_GREEN=32            # set green foreground
CLR_YELLOW=33           # set brown foreground
CLR_LIGHT_YELLOW=93
CLR_BLUE=34             # set blue foreground
CLR_LIGHT_BLUE=94
CLR_MAGENTA=35          # set magenta foreground
CLR_LIGHT_MAGENTA=95
CLR_CYAN=36             # set cyan foreground
CLR_LIGHT_CYAN=96
CLR_WHITE=37            # set white foreground
CLR_LIGHT_GRAY=37
CLR_DARK_GRAY=90

CLR_BLACKB=40           # set black background
CLR_REDB=41             # set red background
CLR_GREENB=42           # set green background
CLR_BROWNB=43           # set brown background
CLR_BLUEB=44            # set blue background
CLR_MAGENTAB=45         # set magenta background
CLR_CYANB=46            # set cyan background
CLR_WHITEB=47           # set white background

# See: http://stackoverflow.com/a/19501528/599258
# NON_PRINTABLE_START="\001"
# NON_PRINTABLE_STOP="\002"
#
# See: https://superuser.com/a/301355/93702
NON_PRINTABLE_START="\x01"
NON_PRINTABLE_STOP="\x02"

# General function to wrap string with escape seqence(s).
# Ex: clr_escape foobar $CLR_RED $CLR_BOLD
function clr_escape
{
    local result="$1"
    until [ -z "$2" ]; do
	      if ! [ $2 -ge 0 -a $2 -le 97 ] 2>/dev/null; then
	          echo "clr_escape: argument \"$2\" is out of range" >&2 && return 1
	      fi
        # Broken:
        # result="${CLR_ESC}${2}m${result}${CLR_ESC}${CLR_RESET}m"
        #
        # Fixes (I think) multiline commands being overwritten:
        result="${NON_PRINTABLE_START}${CLR_ESC}${2}m${NON_PRINTABLE_STOP}${result}${NON_PRINTABLE_START}${CLR_ESC}${CLR_RESET}m${NON_PRINTABLE_STOP}"

	      shift || break
    done

    # echo -e "$NON_PRINTABLE_START$result$NON_PRINTABLE_STOP"
    echo -e "$result"
}

function clr_reset           { clr_escape "$1" $CLR_RESET;           }
function clr_reset_underline { clr_escape "$1" $CLR_RESET_UNDERLINE; }
function clr_reset_reverse   { clr_escape "$1" $CLR_RESET_REVERSE;   }
function clr_default         { clr_escape "$1" $CLR_DEFAULT;         }
function clr_defaultb        { clr_esacpe "$1" $CLR_DEFAULTB;        }
function clr_bold            { clr_escape "$1" $CLR_BOLD;            }
function clr_bright          { clr_escape "$1" $CLR_BRIGHT;          }
function clr_underscore      { clr_escape "$1" $CLR_UNDERSCORE;      }
function clr_reverse         { clr_escape "$1" $CLR_REVERSE;         }
function clr_black           { clr_escape "$1" $CLR_BLANK;           }
function clr_red             { clr_escape "$1" $CLR_RED;             }
function clr_green           { clr_escape "$1" $CLR_GREEN;           }
function clr_brown           { clr_escape "$1" $CLR_BROWN;           }
function clr_blue            { clr_escape "$1" $CLR_BLUE;            }
function clr_magenta         { clr_escape "$1" $CLR_MAGENTA;         }
function clr_cyan            { clr_escape "$1" $CLR_CYAN;            }
function clr_white           { clr_escape "$1" $CLR_WHITE;           }
function clr_blackb          { clr_escape "$1" $CLR_BLACKB;          }
function clr_redb            { clr_escape "$1" $CLR_REDB;            }
function clr_greenb          { clr_escape "$1" $CLR_GREENB;          }
function clr_brownb          { clr_escape "$1" $CLR_BROWNB;          }
function clr_blueb           { clr_escape "$1" $CLR_BLUEB;           }
function clr_magentab        { clr_escape "$1" $CLR_MAGENTAB;        }
function clr_cyanb           { clr_escape "$1" $CLR_CYANB;           }
function clr_whiteb          { clr_escape "$1" $CLR_WHITEB;          }

# Outputs colors table
function clr_dump
{
    local T='gYw'

    echo -e "\n                 40m     41m     42m     43m     44m     45m     46m     47m";

    for FGs in '   0m' '   1m' '  30m' '1;30m' '  31m' '1;31m' \
               '  32m' '1;32m' '  33m' '1;33m' '  34m' '1;34m' \
               '  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m';
    do
        FG=${FGs// /}
        echo -en " $FGs \033[$FG  $T  "
        for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
            echo -en " \033[$FG\033[$BG  $T  \033[0m";
        done
        echo;
    done

    echo
    clr_bold "    Code     Function           Variable"
    echo \
'    0        clr_reset          $CLR_RESET
    1        clr_bold           $CLR_BOLD
    2        clr_bright         $CLR_BRIGHT
    4        clr_underscore     $CLR_UNDERSCORE
    7        clr_reverse        $CLR_REVERSE

    30       clr_black          $CLR_BLACK
    31       clr_red            $CLR_RED
    32       clr_green          $CLR_GREEN
    33       clr_brown          $CLR_BROWN
    34       clr_blue           $CLR_BLUE
    35       clr_magenta        $CLR_MAGENTA
    36       clr_cyan           $CLR_CYAN
    37       clr_white          $CLR_WHITE

    40       clr_blackb         $CLR_BLACKB
    41       clr_redb           $CLR_REDB
    42       clr_greenb         $CLR_GREENB
    43       clr_brownb         $CLR_BROWNB
    44       clr_blueb          $CLR_BLUEB
    45       clr_magentab       $CLR_MAGENTAB
    46       clr_cyanb          $CLR_CYANB
    47       clr_whiteb         $CLR_WHITEB
'
}

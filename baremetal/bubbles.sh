#!/bin/bash

# Function to split command line parameters into two groups:
# one group for parameters before '--' and another for those after.
# Usage: split_parameters param1 param2 -- param3 param4
split_parameters() {
    # Arrays to hold parameters before and after the delimiter '--'
    local params_before=()
    local params_after=()

    # Flag to indicate if the delimiter '--' has been found
    local delimiter_found=0

    # Iterate over each passed argument
    for param in "$@"; do
        # Check if the current parameter is the delimiter
        if [[ $param == "--" ]]; then
            delimiter_found=1  # Set the flag indicating delimiter found
            continue          # Skip further processing for delimiter
        fi

        # Add the parameter to the appropriate array
        if [[ $delimiter_found -eq 0 ]]; then
            params_before+=("$param")  # Add to params_before if delimiter not found
        else
            params_after+=("$param")   # Add to params_after if delimiter found
        fi
    done

    # Combine parameters from each array into space-separated strings
    before_dashes="${params_before[*]}"
    after_dashes="${params_after[*]}"
}


# Function to get current cursor position
get_cursor_position() {
    # Save cursor position
    echo -en "\033[6n" 

    # Read the response from the terminal
    IFS=';' read -r -d R -a pos

    # Extract rows and columns
    row=$(echo "${pos[0]}" | tr -cd '0-9')
    col=$(echo "${pos[1]}" | tr -cd '0-9')
}



################################################################
###
################################################################
confirm() {
    local message=$1  # Message to be displayed above the buttons

    # Function to draw a button
    # Arguments: x-position, y-position, label, focus
    draw_button() {
        local x=$1
        local y=$2
        local label=$3
        local focus=$4

        # Set focus color
        if [ "$focus" -eq 1 ]; then
            tput setaf 14 # Set foreground color to violet
                tput setab 255 # Set background color to white
            tput rev      # Reverse video mode for standout effect
        fi

        # Draw the button
        tput cup $((y + 0)) $x  # Adjust y position for message
        echo -n " $label "

        # Reset text attributes
        tput sgr0
    }

    # Initialize
    tput civis  # Hide cursor

    # Display the message in green
    tput setaf 2  # Set text color to green
    echo "$message"
    # tput sgr0     # Reset text attributes

    # Calculate positions for buttons
    get_cursor_position

    local lines_above=$(( row + 2 ))
    local confirm_button_y=$((lines_above + 1))
    local cancel_button_y=$((lines_above + 1))


    # Initial focus
    local focus=1

    # Main loop
    while true; do
        # Draw buttons
        draw_button 10 $confirm_button_y "Confirm" $((focus == 1))
        draw_button 20 $cancel_button_y "Cancel" $((focus == 2))

        # Read user input
        IFS= read -rsn1 input

        case $input in
            $'\e')  # Arrow key prefix
                # Read the rest of the escape sequence
                read -rsn2 input
                case $input in
                    '[C')  # Right arrow
                        [ "$focus" -eq 1 ] && focus=2
                        ;;
                    '[D')  # Left arrow
                        [ "$focus" -eq 2 ] && focus=1
                        ;;
                esac
                ;;
            "")  # Enter key
                # Return 0 for Confirm, 1 for Cancel
                if [ "$focus" -eq 1 ]; then
                    tput cnorm  # Show cursor
                    echo; echo
                    return 0
                else
                    tput cnorm  # Show cursor
                    echo; echo
                    return 1
                fi                ;;
            *)  # Ignore other inputs
                ;;
        esac
    done
    # Cleanup
    tput cnorm  # Show cursor
}

# Function definition
# get_input_with_default takes two arguments:
# 1. prompt - The message to show to the user
# 2. default - The default value if the user enters nothing
get_input_with_default() {
    local prompt=$1  # Assign first argument to 'prompt'
    local default=$2 # Assign second argument to 'default'
    local input      # Declare 'input' to store user input

    # Display the prompt to the user, showing the default value
    echo -n "$prompt [$default]: "
    read input  # Read user input into the variable 'input'

    # Check if the input is empty (i.e., user pressed Enter directly)
    if [ -z "$input" ]; then
        input=$default  # If input is empty, use the default value
    fi

    # Output the final input value (user input or default)
    INPUT_WITH_DEFAULT=$input
}


# Function to print text in a given color and bold
# $1 - Color (red, green, blue, yellow, etc.)
# $2 - Text to print
# 
# Example usage
# print_colored_bold "red" "This is bold and red text"
# print_colored_bold "blue" "This is bold and blue text"
print_colored_bold() {
    local color=$1; shift
    local text=$*
    local color_code=""

    # Determine color code
    case $color in
        black) color_code='\033[0;30m' ;;
        red) color_code='\033[0;31m' ;;
        green) color_code='\033[0;32m' ;;
        yellow) color_code='\033[0;33m' ;;
        blue) color_code='\033[0;34m' ;;
        magenta) color_code='\033[0;35m' ;;
        cyan) color_code='\033[0;36m' ;;
        white) color_code='\033[0;39m' ;;
        *) echo "Invalid color"; return 1 ;;
    esac
    
    # Print text in bold and the specified color
    printf "${color_code}\033[1m${text}\033[0m"
}

# Function to display a message and a spinner
# Usage: spinner "Your message here..." -- "command"
spinner() {

    start_spinner() {
        local fgcolor=${BUBBLES_FG_COLOR:-"white"}
        local message=$1
        local pid=$2
        local delay=0.1
        local spinstr='|/-\'

        tput civis

        print_colored_bold "$fgcolor" "$message"
        while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
            local temp=${spinstr#?}
            printf " [%c]  " "$spinstr"
            local spinstr=$temp${spinstr%"$temp"}
            sleep $delay
            printf "\b\b\b\b\b\b"
        done
        printf "    \b\b\b\b"
        tput cnorm
    }

    split_parameters $@
    message=$before_dashes
    command=$after_dashes
    ( $command & echo $! > /tmp/bg_job.pid )
    pid=$(cat /tmp/bg_job.pid)
    start_spinner "$message" $pid
    echo ""
}

function basic_spinner()
{
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b\n"
}

print_in_box() {
    local color="$1"
    local text="$2"
    local length=${#text}
    local padding=$(printf '%*s' "$length")

    # Box-drawing characters
    local upper_left_corner='┌'
    local upper_right_corner='┐'
    local lower_left_corner='└'
    local lower_right_corner='┘'
    local vertical_line='│'

    # Print the top border
    print_colored_bold "$color"  "${upper_left_corner}${padding// /─}${upper_right_corner}\n"

    # Print an empty line above the text
    print_colored_bold "$color" "${vertical_line}${padding}${vertical_line}\n"

    # Print the text within borders
    print_colored_bold "$color" "${vertical_line}${text}${vertical_line}\n"

    # Print an empty line below the text
    print_colored_bold "$color" "${vertical_line}${padding}${vertical_line}\n"

    # Print the bottom border
    print_colored_bold "$color" "${lower_left_corner}${padding// /─}${lower_right_corner}\n"
}

function _tee() {
  if ! [ -t 0 ]; then
    if ! command -v tee >/dev/null; then
      local out="${1:-/dev/null}"
      while IFS= read -r line; do
        echo "$line"
        echo "$line" >> $out
      done
    else
      tee -a "$@"
    fi
  else
    echo "no data from stdin" >&2
    return 1
  fi
}

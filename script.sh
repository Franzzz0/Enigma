#!/usr/bin/env bash
encrypt() {
    value=$(($(get_value "$1") + "$2"))
    if [[ $value -gt 90 ]]; then
        value=$((value - 26))
    fi
    letter=$(get_letter $value)
    echo "Encrypted letter: $letter"    
}
get_value() {
    printf "%d\n" "'$1"
}
get_letter() {
    printf "%b\n" "$(printf "\\%03o" "$1")"
}
echo "Enter an uppercase letter:"
read -r letter
echo "Enter a key:"
read -r key
re_letter='^[A-Z]$'
re_key='^[0-9]$'
if [[ "$letter" =~ $re_letter && "$key" =~ $re_key ]]; then
    encrypt "$letter" "$key"
else
    echo "Invalid key or letter!"
fi

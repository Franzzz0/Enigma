#!/usr/bin/env bash
shift=3
convert() {
    message="$1"
    converted=""
    for (( i=0; i<${#message}; i++ )); do
        char="${message:$i:1}"
        new_char=$(convert_char "$char" "$2")
        converted+="$new_char"
    done
    case "$2" in
        "e")
            echo "Encrypted message:";;
        "d")
            echo "Decrypted message:";;
    esac
    echo "$converted"
}
convert_char() {
    if [[ "$1" = " " ]]; then
        echo " "
    else
        value=$(get_value "$1")
        case "$2" in
            "e")
                value=$((value + "$shift"));;
            "d")
                value=$((value - "$shift"));;
        esac
        if [[ $value -gt 90 ]]; then
            value=$((value - 26))
        elif [[ $value -lt 65 ]]; then
            value=$((value + 26))
        fi
        letter=$(get_letter "$value")
        echo "$letter" 
    fi       
}
get_value() {
    printf "%d\n" "'$1"
}
get_letter() {
    printf "%b\n" "$(printf "\\%03o" "$1")"
}
echo "Type 'e' to encrypt, 'd' to decrypt a message:
Enter a command:"
read -r command
case "$command" in
    "e"|"d")
        echo "Enter a message:"
    	read -r message
    	re_message='^[A-Z ]+$'
    	if [[ "$message" =~ $re_message ]]; then
            convert "$message" "$command"
    	else
            echo "This is not a valid message!"
    	fi
    	;;
    *)
        echo "Invalid command!";;
esac

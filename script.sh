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
create_file() {
    re_file_name='^[a-zA-Z.]+$'
    re_message='^[A-Z ]+$'
    echo "Enter the filename:"
    read -r file_name
    if [[ "$file_name" =~ $re_file_name ]]; then
        echo "Enter a message:"
        read -r message
        if [[ "$message" =~ $re_message ]]; then
            echo "$message" > "$file_name"
            echo "The file was created successfully!"
        else
            echo "This is not a valid message!"
        fi
    else
        echo "File name can contain letters and dots only!"
    fi
}
read_file() {
    echo "File content:"
    cat "$1"
}
encrypt_file() {
    content=$(<"$1")
    encrypted_content=$(convert "$content" e)
    encrypted_file_name="$1"".enc"
    echo "$encrypted_content" >> "$encrypted_file_name"
    rm "$1"
    echo "Success"
}
decrypt_file() {
    file_name="$1"
    content=$(<"$file_name")
    decrypted_content=$(convert "$content" d)    
    decrypted_file_name=${file_name::-4}
    echo "$decrypted_content" >> "$decrypted_file_name"
    rm "$file_name"
    echo "Success"
}
process_file() {
    echo "Enter the filename:"
    read -r file_name
    if [[ -e "$file_name" ]]; then
        case "$1" in
            2)
                read_file "$file_name";;
            3)
                encrypt_file "$file_name";;
            4)
                decrypt_file "$file_name";;
        esac
    else
        echo "File not found!"
    fi
}
echo "Welcome to the Enigma!"
while true; do
    echo "
0. Exit
1. Create a file
2. Read a file
3. Encrypt a file
4. Decrypt a file
Enter an option:"
    read -r input
    case "$input" in
        0)
            echo "See you later!"
            break;;
        1)
            create_file;;
        2|3|4)
            process_file "$input";;
        *)
            echo "Invalid option!";;
    esac
done

#!/usr/bin/env bash
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
    echo "Enter password:"
    read -r password
    input_file="$1"
    output_file="$input_file"".enc"
    openssl enc -aes-256-cbc -e -pbkdf2 -nosalt -in "$input_file" -out "$output_file" -pass pass:"$password" &>/dev/null
    exit_code=$?
    if [[ $exit_code -eq 0 ]]; then
        rm "$input_file"
        echo "Success"
    else
        rm "$output_file"
        echo "Fail"
    fi
}
decrypt_file() {
    echo "Enter password:"
    read -r password
    input_file="$1"
    output_file=${input_file::-4}
    openssl enc -aes-256-cbc -d -pbkdf2 -nosalt -in "$input_file" -out "$output_file" -pass pass:"$password" &>/dev/null
    exit_code=$?
    if [[ $exit_code -eq 0 ]]; then
        rm "$input_file"
        echo "Success"
    else
        rm "$output_file"
        echo "Fail"
    fi
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

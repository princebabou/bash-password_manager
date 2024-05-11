#!/bin/bash

# Function to hash password using SHA-256
hash_password() {
    echo -n "$1" | openssl dgst -sha256 -binary | openssl enc -base64
}

# Main menu
while true; do
    clear
    echo "Password Manager"
    echo "1. Add Password"
    echo "2. Retrieve Password"
    echo "3. Update Password"
    echo "4. Delete Password"
    echo "5. Exit"

    read -p "Enter your choice: " choice

    case $choice in
        1)  # Add Password
            read -p "Enter website or service name: " website
            read -s -p "Enter password: " password
            echo
            read -s -p "Confirm password: " confirm_password
            echo
            if [ "$password" != "$confirm_password" ]; then
                echo "Passwords do not match. Try again."
                sleep 2
                continue
            fi
            hashed_password=$(hash_password "$password")
            echo "$hashed_password" > "$website.txt"
            echo "Password added successfully!"
            sleep 2
            ;;
        2)  # Retrieve Password
            read -p "Enter website or service name: " website
            if [ -f "$website.txt" ]; then
                cat "$website.txt"
            else
                echo "Password not found."
            fi
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        3)  # Update Password
            read -p "Enter website or service name: " website
            if [ -f "$website.txt" ]; then
                read -s -p "Enter new password: " password
                echo
                read -s -p "Confirm new password: " confirm_password
                echo
                if [ "$password" != "$confirm_password" ]; then
                    echo "Passwords do not match. Try again."
                    sleep 2
                    continue
                fi
                hashed_password=$(hash_password "$password")
                echo "$hashed_password" > "$website.txt"
                echo "Password updated successfully!"
            else
                echo "Password not found."
            fi
            sleep 2
            ;;
        4)  # Delete Password
            read -p "Enter website or service name: " website
            if [ -f "$website.txt" ]; then
                rm "$website.txt"
                echo "Password deleted successfully!"
            else
                echo "Password not found."
            fi
            sleep 2
            ;;
        5)  # Exit
            echo "Exiting..."
            exit 0
            ;;
        *)  # Invalid choice
            echo "Invalid choice. Please enter a number between 1 and 5."
            sleep 2
            ;;
    esac
done

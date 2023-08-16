#!/bin/bash

# Check if running with sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "This script requires superuser privileges. Please run with 'sudo'."
    exit 1
fi

# Install necessary dependencies
apt-get update
apt-get install -y curl jq xclip

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    --api-url)
        API_URL="$2"
        shift
        shift
        ;;
    --username)
        USERNAME="$2"
        shift
        shift
        ;;
    --password)
        PASSWORD="$2"
        shift
        shift
        ;;
    --help)
        echo "Usage: $0 --api-url <API_URL> --username <USERNAME> --password <PASSWORD> --commandName <NAME>  [--force]"
        exit 0
        ;;
    --commandName)
        NAME="$2"
        shift
        shift
        ;;
    --force)
        FORCE=true
        shift
        ;;

    *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

# Check if required arguments are provided
if [ -z "$API_URL" ] || [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$NAME" ]; then
    echo "Usage: $0 --api-url <API_URL> --username <USERNAME> --password <PASSWORD>"
    exit 1
fi

if [ -f "/usr/local/bin/$NAME" ] && [ -z "$FORCE" ]; then
    echo "$NAME is already installed. Exiting. If you want to reinstall, use argument --force"
    exit 1
fi

# Generate preToken script

cat <<EOT >$NAME.sh
#!/bin/bash
API_URL="$API_URL"

PAYLOAD=\$(jq -n --arg user "$USERNAME" --arg pass "$PASSWORD" '{"username":\$user,"password":\$pass}')

RESPONSE=\$(curl -s -X POST "\$API_URL" -H "Content-Type: application/json" -d "\$PAYLOAD")

TOKEN=\$(echo "\$RESPONSE" | jq -r '.token')

echo -n "\$RESPONSE" | xclip -selection clipboard

echo "Retrieved token: \$TOKEN (copied to clipboard)"
EOT

# Make the preToken script executable
chmod +x $NAME.sh

# Copy the script to /usr/local/bin
cp $NAME.sh /usr/local/bin/$NAME

echo "Installation complete. You can now use the $NAME command."

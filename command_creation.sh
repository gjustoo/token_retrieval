#!/bin/bash

# Check if running with sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "This script requires superuser privileges. Please run with 'sudo'."
    exit 1
fi

if ! command -v curl &>/dev/null || ! command -v jq &>/dev/null || ! command -v xclip &>/dev/null; then
    echo "Installing necessary dependencies..."
    apt-get update
    apt-get install -y curl jq xclip
fi
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
        echo "Usage: $0 --api-url <API_URL> --username <USERNAME> --password <PASSWORD> --commandName <NAME>  --provenance <PROVENANCE> [--force]"
        exit 0
        ;;
    --commandName)
        NAME="$2"
        shift
        shift
        ;;
    --provenance)
        PROVENANCE="$2"
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
if [ -z "$API_URL" ] || [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$NAME" ] || [ -z "$PROVENANCE" ]; then
    echo "Usage: $0 --api-url <API_URL> --username <USERNAME> --password <PASSWORD> --commandName <NAME>  --provenance <PROVENANCE> [--force]"
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

DEBUG=false


# Parse command-line arguments
while [[ \$# -gt 0 ]]; do
    key="\$1"

    case \$key in
        --debug)
            DEBUG=true
            shift
            ;;
        *)
            echo "Unknown option: \$1"
            exit 1
            ;;
    esac
done

PAYLOAD=\$(jq -n --arg user "$USERNAME" --arg pass "$PASSWORD" --arg provenance "$PROVENANCE" '{"username":\$user,"password":\$pass,"provenance":\$provenance}')

# Display variables if debug mode is enabled
if [ "\$DEBUG" = true ]; then
    echo "API_URL: $API_URL"
    echo "USERNAME: $USERNAME"
    echo "PASSWORD: $PASSWORD"
    echo "PROVENANCE: $PROVENANCE"
    echo "PAYLOAD: \$PAYLOAD"
fi


RESPONSE=\$(curl -s -X POST "\$API_URL" -H "Content-Type: application/json" -d "\$PAYLOAD")

if [ "\$DEBUG" = true ]; then
    echo "RESPONSE: \$RESPONSE"
fi

TOKEN=\$(echo "\$RESPONSE")

echo -n "\$RESPONSE" | xclip -selection clipboard

echo "Retrieved token: \$TOKEN (copied to clipboard)"
EOT

# Make the preToken script executable
chmod +x $NAME.sh

# Copy the script to /usr/local/bin
mv $NAME.sh /usr/local/bin/$NAME

echo "$NAME" >> command_log.txt
echo "Command '$NAME' generated and recorded in command_log.txt."

echo "Installation complete. You can now use the $NAME command."

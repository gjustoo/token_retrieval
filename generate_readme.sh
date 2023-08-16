#!/bin/bash

readme_content=$(cat <<EOF
# Token Command Generator

The **Token Command Generator** is a script that allows you to easily generate and install custom token retrieval commands for different APIs. These commands are then accessible directly from your command-line interface, making token retrieval and clipboard copying a breeze.

## Usage

1. Clone this repository to your local machine:

   \`\`\`bash
   git clone https://github.com/your-username/token-command-generator.git
   cd token-command-generator
   \`\`\`

2. Make sure you have the necessary dependencies installed. If not, run the provided installation script:

   \`\`\`bash
   chmod +x install_dependencies.sh
   ./install_dependencies.sh
   \`\`\`

3. Run the script to generate a token command. You need to provide the API URL, username, password, and a unique command name. Here's the basic usage:

   \`\`\`bash
   ./generate_token_command.sh --api-url "https://api.example.com/token" --username "your_username" --password "your_password" --commandName "getToken"
   \`\`\`

   Replace the values with your specific API details.

4. After running the script, the generated token command will be installed and available for use. You can access it using the provided command name (in the example above, it's \`getToken\`).

## Command Options

- \`--api-url <API_URL>\`: The URL of the API for token retrieval.
- \`--username <USERNAME>\`: The username for authentication.
- \`--password <PASSWORD>\`: The password for authentication.
- \`--commandName <NAME>\`: The desired name for the generated command.
- \`--force\`: Use this option to reinstall a command if it already exists.

## Requirements

- curl
- jq
- xclip

## Examples

Generate a command named \`getMyToken\` for an example API:

\`\`\`bash
./generate_token_command.sh --api-url "https://api.example.com/token" --username "your_username" --password "your_password" --commandName "getMyToken"
\`\`\`

## License

This project is licensed under the [MIT License](LICENSE).
EOF
)

echo "$readme_content" > README.md
echo "README.md file generated."
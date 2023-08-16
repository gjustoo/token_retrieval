# Token Command Generator

The **Token Command Generator** is a script that allows you to easily generate and install custom token retrieval commands for different APIs. These commands are then accessible directly from your command-line interface, making token retrieval and clipboard copying a breeze.

This cli command only works for api that return only the token as the response body. As, at the moment, there is no parse/formatting of the response, it just copies the response raw to the clipboard.

## Usage

1. Clone this repository to your local machine:

   ```bash
   git clone[https://github.com/your-username/token-command-generator.git](https://github.com/gjustoo/token_retrieval)
   cd token_retrieval
   ```

2. Make sure you have the necessary dependencies installed.
- curl
- jq
- xclip
3. Run the script to generate a token command. You need to provide the API URL, username, password, and a unique command name. Here's the basic usage:

   ```bash
   ./generate_token_command.sh --api-url "https://api.example.com/token" --username "your_username" --password "your_password" --commandName "getToken"
   ```

   Replace the values with your specific API details.

4. After running the script, the generated token command will be installed and available for use. You can access it using the provided command name (in the example above, it's `getToken`).

## Command deletion 

   You can delete a generated command by running the delete.sh script. You need to provide the command name as an argument. Here's the basic usage:

      ```bash
      ./delete.sh --delete "getToken"
      ```
   and to list created commands :
      ```bash
      ./delete.sh --list
   ``` 

   Or you can delete a command manually : 
   To delete a command manually , simply remove the corresponding file from the /usr/local/bin/ directory and delete the command name in the command_log.txt file.


## Command Options

- `--api-url <API_URL>`: The URL of the API for token retrieval.
- `--username <USERNAME>`: The username for authentication.
- `--password <PASSWORD>`: The password for authentication.
- `--commandName <NAME>`: The desired name for the generated command.
- `--force`: Use this option to reinstall a command if it already exists.

## Requirements

- curl
- jq
- xclip

## Examples

Generate a command named `getMyToken` for an example API:

```bash
./generate_token_command.sh --api-url "https://api.example.com/token" --username "your_username" --password "your_password" --commandName "getMyToken"
```

## License

This project is licensed under the [MIT License](LICENSE).

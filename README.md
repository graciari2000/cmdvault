# CmdVault

CmdVault saves commands from your terminal history and lets you find them by prefix. Type a prefix such as `kub`, press **Ctrl+Space**, and choose a matching command. The selected command is inserted at your prompt for review; press Enter to run it.

## Install

On Linux or macOS (including WSL), clone the repository and run the setup script:

```sh
git clone https://github.com/graciari2000/cmdvault.git
cd cmdvault
bash setup.sh
```

Restart your terminal. CmdVault installs the `cmdvault` command in `~/.local/bin` and adds the shell integration to Bash and Zsh startup files. Git does not execute scripts automatically during clone, so run `bash setup.sh` once after cloning.

## Use

- Type any command prefix and press **Ctrl+Space** to list matching saved commands.
- `cmdvault search PREFIX` lists matching commands.
- `cmdvault list` lists saved commands.
- `printf '%s' 'your command' | cmdvault add` saves a command manually.

Commands are stored locally in `~/.local/share/cmdvault/commands.json` (or `$XDG_DATA_HOME/cmdvault/commands.json`). Bash and Zsh interactive sessions save commands automatically. Set `CMDVAULT_OFF=1` in a shell to disable saving there.

CmdVault stores command text locally. Avoid entering secrets directly in commands, or disable saving before running them. Windows PowerShell is not currently supported.

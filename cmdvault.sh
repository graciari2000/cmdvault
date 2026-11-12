# CmdVault shell integration
# Installed into ~/.bashrc and ~/.zshrc by setup.sh.
_cmdvault_bin="${CMDVAULT_BIN:-cmdvault}"

# Save each completed command locally. Secrets can be excluded with CMDVAULT_OFF=1.
if [ -n "${BASH_VERSION:-}" ]; then
  _cmdvault_prompt_save() {
    [ "${CMDVAULT_OFF:-0}" = 1 ] && return
    local line
    line=$(HISTTIMEFORMAT= builtin history 1 | sed 's/^ *[0-9]* *//')
    [ -n "$line" ] && printf '%s' "$line" | "$_cmdvault_bin" add >/dev/null 2>&1
  }
  case ";${PROMPT_COMMAND:-};" in *";_cmdvault_prompt_save;"*) ;; *) PROMPT_COMMAND="_cmdvault_prompt_save${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;; esac
  _cmdvault_pick_line() {
    local prefix="$READLINE_LINE" result
    result=$("$_cmdvault_bin" pick "$prefix") || return
    [ -n "$result" ] && READLINE_LINE="$result" && READLINE_POINT=${#READLINE_LINE}
  }
  bind -x '"\C-@": _cmdvault_pick_line' 2>/dev/null
elif [ -n "${ZSH_VERSION:-}" ]; then
  autoload -Uz add-zsh-hook
  _cmdvault_prompt_save() {
    [ "${CMDVAULT_OFF:-0}" = 1 ] && return
    printf '%s' "$(fc -ln -1)" | "$_cmdvault_bin" add >/dev/null 2>&1
  }
  _cmdvault_pick_line() {
    local result
    result=$("$_cmdvault_bin" pick "$BUFFER") || return
    [ -n "$result" ] && BUFFER="$result"
  }
  add-zsh-hook precmd _cmdvault_prompt_save
  zle -N _cmdvault_pick_line
  bindkey '^@' _cmdvault_pick_line
fi

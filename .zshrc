alias ls='ls -G'
alias svenv='source venv/bin/activate'

PROMPT="%F{yellow}%n%f@%m:%F{cyan}[%~]%f %# "

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
zstyle ':vcs_info:*' enable git

source /home/thesorryguy/antigen.zsh

antigen use oh-my-zsh


antigen bundle git
antigen bundle pip
antigen bundle desyncr/auto-ls


antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme romkatv/powerlevel10k

antigen apply

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

source $ZDOTDIR/options.zsh
source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/plugins.zsh
source $ZDOTDIR/functions.zsh

# ローカルPCでだけ使いたい設定
[ -f ~/.local_functions.zsh ] && source ~/.local_functions.zsh

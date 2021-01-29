# git diff-highlight
export PATH=$PATH:/usr/local/share/git-core/contrib/diff-highlight/

# use anyenv
eval "$(anyenv init -)"

# npm completion
source ~/.npm-completion

# include home bin
export PATH="$PATH:$HOME/bin/"

# include scripts
for file in $( ls ~/bash.conf/script/*.sh ); do
    source $file
done

# use completion
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
autoload -U compinit
compinit -u

zsh_project_path="$(dirname $(readlink $0))"

typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin
)

# use anyenv
eval "$(anyenv init -)"

# npm completion
source <(npm completion)

# use completion
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
autoload -U compinit
compinit -u

# include scripts
for file in $( ls $zsh_project_path/script/*.sh ); do
    source $file
done
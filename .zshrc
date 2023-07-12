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

# include scripts
for file in $( ls ~/bash.conf/script/*.sh ); do
    source $file
done

# use completion
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
autoload -U compinit
compinit -u

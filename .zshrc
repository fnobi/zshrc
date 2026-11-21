zsh_project_path="${${(%):-%x}:A:h}"

# ============================================================
# PATH
#   ここに集約する。(N-/) で存在しないディレクトリは無視される
#   typeset -U で重複は自動的に除去される
# ============================================================
typeset -U path PATH

# システム / Homebrew
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
  $HOME/bin(N-/)
)

# anyenv（各 env の shims を先頭に追加する）
eval "$(anyenv init -)"

# 各種ツール（anyenv の shims より優先させる）
export PNPM_HOME="$HOME/Library/pnpm"
path=(
  $HOME/.local/bin(N-/)
  $HOME/.unity/bin(N-/)
  $PNPM_HOME/bin(N-/)
  $HOME/google-cloud-sdk/bin(N-/)
  $path
)

# ============================================================
# 補完
# ============================================================
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
autoload -U compinit
compinit -u

# npm
source <(npm completion)

# gcloud
[[ -f $HOME/google-cloud-sdk/completion.zsh.inc ]] && source $HOME/google-cloud-sdk/completion.zsh.inc

# ============================================================
# 自作スクリプト
# ============================================================
for file in $zsh_project_path/script/*.sh(N); do
  source $file
done

# ============================================================
# shellごとにCLOUDSDK_CONFIGをリセット
# ============================================================

if [[ -z $CLOUDSDK_CONFIG_OWNER ]]; then
  export CLOUDSDK_CONFIG=$(mktemp -d "${TMPDIR:-/tmp}/gcloud.XXXXXX")
  export CLOUDSDK_CONFIG_OWNER=$$
fi
zshexit() {
  [[ $CLOUDSDK_CONFIG_OWNER == $$ ]] && rm -rf "$CLOUDSDK_CONFIG"
}

# ============================================================
# 起動時表示
# ============================================================
# 現在の gcloud ADC / gh アカウントを表示
[[ -o interactive ]] && show_accounts

# ---- 以下インストーラーによる自動追記。気づいたら上のブロックに移す ----

# シェル起動時に gh のアクティブユーザーを表示する
# 起動を遅くしないよう、gh コマンドは使わずローカルの設定ファイルを読むだけにしている

# gh CLI の github.com アクティブユーザー
_gh_active_user() {
  local hosts="${GH_CONFIG_DIR:-$HOME/.config/gh}/hosts.yml"
  [[ -f "$hosts" ]] || { echo "(未ログイン)"; return; }
  awk '
    /^[^ ]/ { in_host = ($0 == "github.com:") }
    in_host && /^    user:/ { print $2; exit }
  ' "$hosts"
}

show_accounts() {
  printf '\e[2mgh:\e[0m %s\n' "$(_gh_active_user)"
}

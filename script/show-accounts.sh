# シェル起動時に gcloud の ADC と gh のアクティブユーザーを表示する
# 起動を遅くしないよう、基本はローカルのファイルを読むだけにしている

# gcloud Application Default Credentials のアカウント
_adc_account() {
  local adc="${CLOUDSDK_CONFIG:-$HOME/.config/gcloud}/application_default_credentials.json"
  [[ -f "$adc" ]] || { echo "(未設定)"; return; }

  local type account
  type=$(jq -r '.type // empty' "$adc" 2>/dev/null)
  case "$type" in
    service_account)
      jq -r '.client_email // "(不明)"' "$adc"
      return ;;
    impersonated_service_account)
      jq -r '.service_account_impersonation_url // ""' "$adc" | sed -E 's#.*/serviceAccounts/([^:]+):.*#\1 (impersonated)#'
      return ;;
  esac

  account=$(jq -r '.account // empty' "$adc" 2>/dev/null)
  if [[ -n "$account" ]]; then
    echo "$account"
    return
  fi

  # authorized_user でアカウント名が入っていない場合はトークンから引く。
  # 結果は ADC ファイルの更新時刻をキーにキャッシュする（ADC が変わった時だけ通信する）
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zshrc/adc_account"
  local key
  key=$(stat -f %m "$adc" 2>/dev/null)
  if [[ -f "$cache" && "$(head -1 "$cache")" == "$key" ]]; then
    sed -n 2p "$cache"
    return
  fi

  local token
  token=$(gcloud auth application-default print-access-token 2>/dev/null)
  if [[ -n "$token" ]]; then
    account=$(curl -s --max-time 3 "https://oauth2.googleapis.com/tokeninfo?access_token=$token" | jq -r '.email // empty')
  fi
  if [[ -n "$account" ]]; then
    mkdir -p "${cache:h}"
    printf '%s\n%s\n' "$key" "$account" > "$cache"
    echo "$account"
  else
    echo "(取得失敗)"
  fi
}

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
  printf '\e[2mgcloud:\e[0m %s\n' "$(_adc_account)"
  printf '\e[2mgh    :\e[0m %s\n' "$(_gh_active_user)"
}

function myip () {
    local cmd="curl https://ifconfig.me/ip"
    echo "$cmd"
    eval "$cmd"
}

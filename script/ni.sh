function ni () {
    if [ -f ./yarn.lock ] ; then
        yarn $@
    elif [ -f ./pnpm-lock.yaml ] ; then
        pnpm $@
    elif [ -f ./package-lock.json ] ; then
        npm $@
    else
        echo "lock file is not found."
    fi
}

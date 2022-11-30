alias vim='nvim'
alias v='nvim'

dexec() {
    local DEFAULT_INTERFACE="/bin/bash"
    local interface="${2:-$DEFAULT_INTERFACE}"
    docker exec -it $1 $interface
}
dcleanall() {
    for c in `sudo docker ps -a | awk '/^[^C]/{print $1}'`
    do
        sudo docker rm -f $c
    done
}

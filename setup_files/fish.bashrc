set -a; source /etc/environment; set +a

if [[ $- == *i* ]]
then
    exec fish
fi

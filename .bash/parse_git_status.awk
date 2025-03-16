BEGIN {
    FS="[ (]"
}
/On branch/ { branch=$3 }
/interacti/ { rebase=1 }
/Last comm/ { done=$5 }
/Next comm/ { todo=$6 }
END {
    if (branch) {
        print branch
    } else if (rebase) {
        printf "REBASE %s/%s",done,done+todo
    }
}

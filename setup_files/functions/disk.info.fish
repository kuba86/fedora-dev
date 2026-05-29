function disk.info
    if test -e "$HOME/dysk"
        wrap-with-dashes "Dysk"
        $HOME/dysk --cols fs+label+type+disk+used+use+free+size+mp
    end

    wrap-with-dashes "Local Disks"
    lsblk --fs --output=NAME,MODEL,LABEL,SIZE,FSAVAIL,FSUSED,FSUSE%,PATH,ROTA,TRAN,TYPE,FSTYPE,MOUNTPOINTS
end

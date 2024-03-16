function disk.info
    lsblk --fs --output=NAME,SIZE,FSAVAIL,FSUSED,FSUSE%,RO,TYPE,FSTYPE,LABEL,MOUNTPOINT
end

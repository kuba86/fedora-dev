function rand-easy
  head -c 1024 /dev/urandom | tr -dc [:upper:][:digit:] | head -c $argv[1]; echo
end

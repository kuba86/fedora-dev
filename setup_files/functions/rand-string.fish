function rand-string
  head -c 1024 /dev/urandom | tr -dc [:alnum:] | head -c $argv[1]; echo
end

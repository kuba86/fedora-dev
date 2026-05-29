function rand
	head -c 1024 /dev/urandom | tr -dc [:graph:] | head -c $argv[1]; echo
end

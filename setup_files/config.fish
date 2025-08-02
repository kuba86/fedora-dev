if status is-interactive
    fish_config theme choose "ayu Dark"
end

set -Ua fish_features no-keyboard-protocols

# Read /etc/environment and set variables in fish
if test -f /etc/environment
    for line in (cat /etc/environment | grep -v '^#' | grep -v '^$')
        set -l parts (string split '=' $line)
        if test (count $parts) -eq 2
            set -gx $parts[1] $parts[2]
        end
    end
end

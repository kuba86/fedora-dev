function cmd-monitor
    # Define arguments
    # Note: We define full names and 2-letter aliases as separate long options.
    # command-background takes a value because your example used =false

    # Example:
    #     cmd-monitor \
    #       --command="sudo btrfs scrub start /var/mnt/2tb-ssd" \
    #       --command-background="true" \
    #       --check-time=10 \
    #       --check-command="sudo btrfs scrub status /var/mnt/2tb-ssd" \
    #       --running-grep="status finished"

    argparse --name=cmd-monitor \
        'command=' 'cmd=' \
        'command-background=' 'cb=' \
        'check-time=' 'ct=' \
        'check-command=' 'cc=' \
        'running-grep=' 'rg=' -- $argv
    or return 1

    # --- 1. Consolidate Aliases ---
    # Check if the 2-letter alias was set and map it to the main variable
    if set -q _flag_ct; set _flag_check_time $_flag_ct; end
    if set -q _flag_cc; set _flag_check_command $_flag_cc; end
    if set -q _flag_cb; set _flag_command_background $_flag_cb; end
    if set -q _flag_cmd; set _flag_command $_flag_cmd; end
    if set -q _flag_rg; set _flag_running_grep $_flag_rg; end

    # --- 2. Validate Required Arguments ---
    if not set -q _flag_command
        echo "Error: --command (or --cmd) is required."
        return 1
    end

    if not set -q _flag_check_time
        echo "Error: --check-time (or --ct) is required."
        return 1
    end

    if not set -q _flag_check_command
        echo "Error: --check-command (or --cc) is required."
        return 1
    end

    # --- 3. Execute the Main Command ---
    echo "Starting command: $_flag_command"

    # Determine if backgrounding is requested
    set -l run_in_bg "false"
    if set -q _flag_command_background
        # Check for explicit "true" string
        if string match -q -i "true" "$_flag_command_background"
            set run_in_bg "true"
        end
    end

    if test "$run_in_bg" = "true"
        # Run in background
        eval $_flag_command &
        echo "Command running in background..."
    else
        # Run in foreground
        eval $_flag_command
    end

    # --- 4. Start the Monitoring Loop ---
    echo "Starting monitor loop every $_flag_check_time seconds..."

    while true
        sleep $_flag_check_time

        echo "Running check: $_flag_check_command"

        # Capture output (stderr and stdout) as a list of lines
        set -l check_output (eval $_flag_check_command 2>&1)

        # Print output to console
        printf "%s\n" $check_output

        # --- 5. Check Grep Conditions ---
        if set -q _flag_running_grep
            # Split input keywords by space
            set -l keywords (string split -n " " -- $_flag_running_grep)

            # Escape keywords for regex safety
            set -l escaped_keywords
            for kw in $keywords
                set -a escaped_keywords (string escape --style=regex -- $kw)
            end

            # Create regex: word1.*word2.*word3
            set -l pattern (string join ".*" -- $escaped_keywords)

            # Check matches against the output list
            # -q: quiet
            # -i: ignore case
            # -r: regex mode
            if string match -q -i -r -- "$pattern" $check_output
                echo "Match found for '$_flag_running_grep'. Stopping monitor."
                break
            end
        end
    end
end

function wrap-with-dashes --description "Wrap and center text (with dashes)";
    set -l description $argv[1]
    set -l max_width 70
    set -l text_length (string length " $description ")
    set -l remaining (math -s0 "$max_width - $text_length")
    set -l left_dashes (math -s0 "$remaining / 2")
    set -l right_dashes (math -s0 "$remaining - $left_dashes")

    string repeat -m $max_width -
    string repeat --no-newline -n $left_dashes -
    echo -n " $description "
    string repeat -n $right_dashes -
    string repeat --no-newline -m $max_width -
    echo
  end

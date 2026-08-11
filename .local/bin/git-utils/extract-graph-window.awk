# Extracts a fixed-size window of `lines` centered on `hash`'s line, and
# flags whether `dhash` (with `msg`) falls above or below that window.
# Used by git-graph. Expects -v hash=... -v dhash=... -v msg=... -v n=...

{ lines[NR] = $0 }
index($0, hash) { head_line = NR }
dhash != "" && index($0, dhash) { default_line = NR }
END {
    start = head_line - n; if (start < 1) start = 1
    end = head_line + n; if (end > NR) end = NR
    if (msg != "" && default_line > 0 && default_line < start) print "↑ " msg
    for (i = start; i <= end; i++) print lines[i]
    if (msg != "" && default_line > 0 && default_line > end) print "↓ " msg
}

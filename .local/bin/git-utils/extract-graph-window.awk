# Extracts a fixed-size window of `lines` centered on `hash`'s line, and flags
# which of the refs in `specs` fall above or below that window. `specs` is a
# flat hash/message list joined on ASCII 31.
# Used by git-graph and git-switch-fuzzy.
# Expects -v hash=... -v specs=... -v n=...

BEGIN {
    fields = split(specs, spec, "\037")
    for (i = 1; i < fields; i += 2)
    {
        refs++
        ref_hash[refs] = spec[i]
        ref_msg[refs] = spec[i + 1]
    }
}
{ lines[NR] = $0 }
index($0, hash) { head_line = NR }
{ for (i = 1; i <= refs; i++) if (index($0, ref_hash[i])) ref_line[i] = NR }
END {
    start = head_line - n; if (start < 1) start = 1
    end = head_line + n; if (end > NR) end = NR

    # walking line numbers instead of sorting keeps the nearest indicator
    # adjacent to the graph: last above it, first below it
    for (line = 1; line < start; line++)
        for (i = 1; i <= refs; i++) if (ref_line[i] == line) print "↑ " ref_msg[i]

    for (i = start; i <= end; i++) print lines[i]

    for (line = end + 1; line <= NR; line++)
        for (i = 1; i <= refs; i++) if (ref_line[i] == line) print "↓ " ref_msg[i]
}

#!/usr/bin/awk -f
# Remove the largest indent common to all non-blank lines of stdin.
#
# Only spaces count as indentation. A line indented with a tab therefore has an
# indent of 0, so a block mixing tabs and spaces is left untouched rather than
# being mangled.

{ line[NR] = $0 }

END {
  margin = -1
  for (i = 1; i <= NR; i++) {
    if (line[i] ~ /[^ \t]/) {            # ignore blank / whitespace-only lines
      match(line[i], /^ */)
      if (margin < 0 || RLENGTH < margin) margin = RLENGTH
      if (margin == 0) break              # nothing to strip, stop early
    }
  }
  if (margin < 0) margin = 0              # input was entirely blank
  for (i = 1; i <= NR; i++) print substr(line[i], margin + 1)
}

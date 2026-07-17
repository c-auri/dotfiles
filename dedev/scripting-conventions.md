# Scripting Conventions

## Philosophy

- Prioritize portability and simplicity over raw performance, scripts should generally run without a build step
- Rewrite for performance when it becomes a bottleneck, not before

## Shell Scripts

### Language Choice

- Default options: sh, bash, awk, Python
- Other languages need good reason + approval in the planning process

### Naming

- Use kebab-case (e.g., `sync-db-snapshots`, `validate-schema`)
- Keep short but readable
- Names should hint at purpose

### Structure and Formatting

- Shebang, blank line, then first code
- Brief comment at top explaining what the script does
- Allman-style control flow statements: `then`, `do`, etc. on new line, no `;` before the break

**Correct:**
```bash
#!/bin/bash

# Syncs database snapshots from production to dev

if [[ $? -eq 0 ]]
then
  echo "Success"
fi
```

**Incorrect:**
```bash
#!/bin/bash
if [[ $? -eq 0 ]]; then
  echo "Success"
fi
```

### Comments

- Explain the *why* behind important decisions
- Explain non-obvious *what*: if terse shell syntax isn't immediately clear to someone unfamiliar with it, explain it
  - For complex regexes: include explanation and examples
  - For abbreviation-heavy arguments: clarify what they do

### Error Handling

- Fail fast — don't continue after a fatal error
- No exit code specification yet; add as needed

### System Compatibility

- Primary target: recent Ubuntu systems
- Keep in mind compatibility with other Unix-like systems

## README Style

- Individual components should have a README close to the relevant code
- Short and focused
- Include: 
  - what it's for
  - what it does
  - dependencies
  - design decisions
  - verification steps
- Skip: 
  - UI walkthroughs
  - visual minutiae
  - file or feature tables when prose covers them
- Leave no open decisions — document what you've decided
- Explanations for implementation details go in code comments, not the README


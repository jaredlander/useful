# Bash Code Review Reference

## Priority Focus
- Safety and error handling
- Security (injection, quoting)
- Portability
- Readability

## Safety and Error Handling

### Strict Mode
```bash
# GOOD: Enable strict mode at script start
#!/bin/bash
set -euo pipefail

# -e: Exit on error
# -u: Error on undefined variables
# -o pipefail: Pipeline fails if any command fails

# For debugging, add:
set -x  # Print commands as executed
```

### Error Handling Patterns
```bash
# BAD: No error handling
rm -rf "$dir"
cd "$dir"
do_stuff

# GOOD: Check critical operations
if ! rm -rf "$dir"; then
    echo "Failed to remove $dir" >&2
    exit 1
fi

# GOOD: Use || for fallback
cd "$dir" || exit 1

# GOOD: Trap for cleanup
cleanup() {
    rm -rf "$temp_dir"
}
trap cleanup EXIT ERR

temp_dir=$(mktemp -d)
```

### Undefined Variables
```bash
# BAD: Unquoted, might be undefined
rm -rf $MYDIR/*  # If MYDIR is empty: rm -rf /*  !!!

# GOOD: Quote and provide default
rm -rf "${MYDIR:?MYDIR must be set}/"*

# Variable defaults
${var:-default}     # Use default if unset or empty
${var:=default}     # Set to default if unset or empty
${var:?error msg}   # Exit with error if unset or empty
${var:+value}       # Use value if var is set
```

## Quoting and Expansion

### Always Quote Variables
```bash
# BAD: Unquoted variables
file=$1
rm $file  # Word splitting, glob expansion!
if [ $var = "value" ]; then  # Fails if var is empty

# GOOD: Double-quote variables
file="$1"
rm "$file"
if [ "$var" = "value" ]; then
```

### When to Quote
```bash
# Always quote:
"$variable"
"$(command)"
"${array[@]}"  # Preserves array elements

# Don't quote:
# - Integer comparisons in [[ ]]
[[ $count -gt 5 ]]
# - Glob patterns when globbing is intended
for file in *.txt; do
```

### Prefer [[ ]] Over [ ]
```bash
# BAD: [ ] has quirks
[ $var = "value" ]        # Fails if var is empty
[ -n $var ]               # Always true!

# GOOD: [[ ]] is safer
[[ "$var" = "value" ]]    # Works even if empty
[[ -n "$var" ]]           # Correct behavior
[[ "$var" =~ ^[0-9]+$ ]]  # Regex support
```

## Security

### Command Injection
```bash
# BAD: User input in command
user_input="$1"
eval "echo $user_input"        # Arbitrary code execution!
bash -c "process $user_input"  # Same problem

# BAD: Unvalidated in dangerous commands
rm -rf "$user_input"

# GOOD: Validate input
if [[ ! "$user_input" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "Invalid input" >&2
    exit 1
fi

# GOOD: Use -- to prevent option injection
rm -- "$user_input"
grep -- "$pattern" "$file"
```

### SQL/Command Building
```bash
# BAD: String interpolation
mysql -e "SELECT * FROM users WHERE name = '$username'"

# GOOD: Use parameterized queries or proper escaping
mysql -e "SELECT * FROM users WHERE name = ?" --param "$username"
```

### Temporary Files
```bash
# BAD: Predictable temp file
temp_file="/tmp/myapp_temp"  # Race condition, symlink attack

# GOOD: Use mktemp
temp_file=$(mktemp)
temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_file" "$temp_dir"' EXIT
```

### Path Handling
```bash
# BAD: Assuming current directory
source config.sh  # May load wrong file

# GOOD: Use script's directory
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/config.sh"
```

## Best Practices

### Functions
```bash
# GOOD: Use functions for reusability
log_error() {
    local message="$1"
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $message" >&2
}

# GOOD: Use local variables
process_file() {
    local file="$1"
    local -r readonly_var="constant"  # -r for readonly
    local result
    result=$(do_something "$file")
    echo "$result"
}
```

### Arrays
```bash
# GOOD: Use arrays for lists
files=("file1.txt" "file 2.txt" "file3.txt")

# Iterate preserving spaces
for file in "${files[@]}"; do
    process "$file"
done

# Array length
echo "${#files[@]}"

# Append to array
files+=("another.txt")
```

### Command Substitution
```bash
# GOOD: $() over backticks
result=$(command)

# GOOD: Quote the result
file_count="$(ls -1 | wc -l)"

# Capture both stdout and stderr
output=$(command 2>&1)

# Capture exit code
if output=$(command 2>&1); then
    echo "Success: $output"
else
    echo "Failed: $output" >&2
fi
```

### Argument Handling
```bash
# GOOD: Use getopts for options
while getopts ":hv:o:" opt; do
    case $opt in
        h) show_help; exit 0 ;;
        v) verbose="$OPTARG" ;;
        o) output="$OPTARG" ;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires argument" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

# Remaining args in "$@"
for arg in "$@"; do
    process "$arg"
done
```

## Performance

### Avoid Unnecessary Subshells
```bash
# BAD: Subshell for simple variable
result=$(echo "$var" | tr 'a-z' 'A-Z')

# GOOD: Bash built-in
result="${var^^}"  # Uppercase
result="${var,,}"  # Lowercase

# BAD: External command for string ops
length=$(echo "$string" | wc -c)

# GOOD: Parameter expansion
length="${#string}"
```

### Avoid Useless Cat
```bash
# BAD: Useless use of cat
cat file.txt | grep pattern

# GOOD: Direct file argument
grep pattern file.txt
```

### Process Substitution
```bash
# Compare two command outputs
diff <(sort file1) <(sort file2)

# Read from command without subshell variable scope issue
while read -r line; do
    process "$line"
done < <(command)
```

## Portability

### Shebang
```bash
# Most portable
#!/usr/bin/env bash

# Or explicit path
#!/bin/bash
```

### POSIX Compatibility
```bash
# Bash-specific (not POSIX):
[[ ]]           # Use [ ] for POSIX
$(( ))          # Arithmetic
${var//pat/rep} # Pattern substitution
<<<             # Here-string
arrays          # Not in POSIX sh
```

### Common Gotchas
```bash
# Flag: echo -e (not portable)
echo -e "line1\nline2"  # May not work

# GOOD: Use printf
printf "line1\nline2\n"

# Flag: bash-specific in /bin/sh script
#!/bin/sh
[[ "$var" == "value" ]]  # Won't work!
```

## Common Pitfalls

- Missing quotes around variables
- Using `[ ]` instead of `[[ ]]`
- Not using `set -euo pipefail`
- Parsing `ls` output (use globs instead)
- Not handling filenames with spaces
- Using `$*` instead of `$@`
- Modifying variables in pipelines (subshell scope)
- Not using `--` to end option parsing

## Documentation Standards

```bash
#!/bin/bash
#
# script-name.sh - Brief description
#
# Usage: script-name.sh [OPTIONS] <required-arg>
#
# Options:
#   -h          Show this help
#   -v          Verbose output
#   -o FILE     Output file
#
# Arguments:
#   required-arg  Description of required argument
#
# Examples:
#   script-name.sh -v input.txt
#   script-name.sh -o output.txt input.txt
#
# Exit codes:
#   0 - Success
#   1 - General error
#   2 - Invalid arguments

set -euo pipefail
```

## Testing with Bats

```bash
#!/usr/bin/env bats

@test "script returns success" {
    run ./script.sh valid-input
    [ "$status" -eq 0 ]
}

@test "script handles missing arg" {
    run ./script.sh
    [ "$status" -eq 2 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "script processes file correctly" {
    run ./script.sh test-input.txt
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Expected output" ]
}
```

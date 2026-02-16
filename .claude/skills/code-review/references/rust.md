# Rust Code Review Reference

## Priority Focus
- Idiomatic Rust patterns
- Error handling
- Ownership and borrowing correctness
- Performance (zero-cost abstractions)

## Ownership and Borrowing

### Common Issues
```rust
// Flag: Unnecessary clones
let data = get_data();
process(data.clone());  // Is clone needed?

// Better: Borrow if possible
process(&data);

// Flag: Holding borrows too long
let borrowed = &mut self.data;
// ... lots of code ...
self.other_method();  // Error: self already borrowed

// Better: Limit borrow scope
{
    let borrowed = &mut self.data;
    // Use it
}
self.other_method();  // OK now
```

### Lifetime Patterns
```rust
// Flag: Unnecessary lifetime annotations
fn process<'a>(s: &'a str) -> &'a str { s }  // 'a is inferred
fn process(s: &str) -> &str { s }  // Cleaner

// Flag: 'static when not needed
fn process(s: &'static str) { ... }  // Too restrictive?
```

## Error Handling

### Prefer
```rust
// Use ? operator for propagation
fn read_config() -> Result<Config, Error> {
    let contents = std::fs::read_to_string("config.toml")?;
    let config: Config = toml::from_str(&contents)?;
    Ok(config)
}

// Provide context with anyhow/thiserror
use anyhow::{Context, Result};
fn read_config() -> Result<Config> {
    let contents = std::fs::read_to_string("config.toml")
        .context("Failed to read config file")?;
    Ok(toml::from_str(&contents)?)
}

// Custom error types for libraries
#[derive(Debug, thiserror::Error)]
pub enum ConfigError {
    #[error("Failed to read file: {0}")]
    ReadError(#[from] std::io::Error),
    #[error("Invalid TOML: {0}")]
    ParseError(#[from] toml::de::Error),
}
```

### Avoid
```rust
// Flag: unwrap() in production code
let value = map.get("key").unwrap();  // Panics!

// Better: Handle the None case
let value = map.get("key").ok_or(Error::MissingKey)?;
// Or provide default
let value = map.get("key").unwrap_or(&default);

// Flag: expect() without useful message
let value = result.expect("failed");  // Not helpful

// Better: Descriptive message
let value = result.expect("database connection should be established during init");
```

## Idiomatic Patterns

### Iterator Usage
```rust
// BAD: Manual iteration
let mut results = Vec::new();
for item in items {
    if item.is_valid() {
        results.push(item.transform());
    }
}

// GOOD: Iterator chain
let results: Vec<_> = items
    .iter()
    .filter(|item| item.is_valid())
    .map(|item| item.transform())
    .collect();

// Use iterator methods
items.iter().any(|x| x.is_valid())
items.iter().find(|x| x.id == target_id)
items.iter().position(|x| x.matches())
```

### Option/Result Methods
```rust
// BAD: Match when method exists
match opt {
    Some(v) => Some(transform(v)),
    None => None,
}

// GOOD: Use map
opt.map(transform)

// BAD: Nested matching
match outer {
    Some(inner) => match inner.value {
        Some(v) => process(v),
        None => default(),
    },
    None => default(),
}

// GOOD: Chained methods
outer
    .and_then(|inner| inner.value)
    .map(process)
    .unwrap_or_else(default)
```

### Pattern Matching
```rust
// Use if let for single patterns
if let Some(value) = optional {
    process(value);
}

// Use matches! macro
if matches!(value, Pattern::A | Pattern::B) { ... }

// Destructure in match arms
match result {
    Ok(Data { id, name, .. }) => println!("{}: {}", id, name),
    Err(e) => eprintln!("Error: {}", e),
}
```

## Performance

### Allocation Avoidance
```rust
// BAD: Unnecessary allocation
fn process(s: &str) -> String {
    s.to_string()  // Allocates even if not needed
}

// GOOD: Use Cow for conditional allocation
use std::borrow::Cow;
fn process(s: &str) -> Cow<'_, str> {
    if needs_modification(s) {
        Cow::Owned(modify(s))
    } else {
        Cow::Borrowed(s)
    }
}

// Prefer &str over String in parameters
fn process(s: &str) { ... }  // Accepts &String and &str
```

### Collection Pre-allocation
```rust
// BAD
let mut v = Vec::new();
for i in 0..1000 {
    v.push(compute(i));
}

// GOOD
let mut v = Vec::with_capacity(1000);
for i in 0..1000 {
    v.push(compute(i));
}

// Or use collect with size hint
let v: Vec<_> = (0..1000).map(compute).collect();
```

### Avoid Unnecessary Clones
```rust
// Flag: Clone in hot paths
for item in items {
    process(item.clone());  // Needed?
}

// Consider borrowing
for item in &items {
    process(item);
}
```

## Security Checks

### Unsafe Code
```rust
// Flag all unsafe blocks - require justification
unsafe {
    // SAFETY: Explain why this is safe
    ptr::read(ptr)
}

// Common unsafe issues:
// - Dereferencing raw pointers without null check
// - Transmute between incompatible types
// - Missing SAFETY comments
```

### Input Validation
```rust
// Flag: Unchecked array indexing
let value = data[user_index];  // Can panic!

// Better: Use get()
let value = data.get(user_index).ok_or(Error::InvalidIndex)?;
```

## Common Pitfalls

- Using `&String` instead of `&str`
- `impl Trait` vs generics inconsistency
- Missing `#[must_use]` on Result-returning functions
- Forgetting `#[derive(Debug)]` on public types
- Not implementing standard traits (Clone, Default, etc.)
- Using `Box<dyn Trait>` when generics work

## Documentation Standards

```rust
/// Brief description.
///
/// Longer description with examples.
///
/// # Arguments
///
/// * `x` - Description
///
/// # Returns
///
/// Description of return value
///
/// # Errors
///
/// Returns `Error::InvalidInput` if x is negative
///
/// # Examples
///
/// ```
/// let result = my_function(5)?;
/// assert_eq!(result, 25);
/// ```
///
/// # Panics
///
/// Panics if internal invariant is violated (should never happen)
pub fn my_function(x: i32) -> Result<i32, Error> { ... }
```

## Testing

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic() {
        assert_eq!(my_function(2), Ok(4));
    }

    #[test]
    fn test_error() {
        assert!(matches!(my_function(-1), Err(Error::InvalidInput)));
    }

    #[test]
    #[should_panic(expected = "invariant")]
    fn test_panic() {
        trigger_panic();
    }
}
```

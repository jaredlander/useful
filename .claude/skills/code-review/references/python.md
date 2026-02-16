# Python Code Review Reference

## Priority Focus
- PEP 8 compliance
- Type hints
- Pythonic idioms
- Security (especially injection, deserialization)

## Style and Idioms

### Prefer
```python
# List/dict/set comprehensions
squares = [x**2 for x in range(10)]
lookup = {item.id: item for item in items}

# Context managers
with open(path) as f:
    data = f.read()

# f-strings for formatting
message = f"Hello, {name}!"

# Unpacking
first, *rest = items
a, b = b, a  # swap

# any/all for boolean checks
if any(x > 0 for x in items):
    pass
```

### Avoid
```python
# Manual loops for simple transforms
squares = []
for x in range(10):
    squares.append(x**2)

# Manual file handling
f = open(path)
data = f.read()
f.close()

# .format() or % when f-strings work
message = "Hello, {}!".format(name)

# Unnecessary indexing
for i in range(len(items)):
    process(items[i])
# Use: for item in items:
```

## Type Hints

### Required Patterns
```python
from typing import Optional, List, Dict, Union, Callable
from collections.abc import Iterable, Sequence

def process(
    items: List[str],
    config: Optional[Dict[str, Any]] = None,
    callback: Callable[[str], None] | None = None,
) -> Dict[str, int]:
    ...

# Use | for unions (Python 3.10+)
def get_value(key: str) -> int | None:
    ...
```

### Flag Missing Types
- Public function parameters and returns
- Class attributes
- Module-level variables

## Security Checks

### Critical Vulnerabilities

**SQL Injection**
```python
# BAD
query = f"SELECT * FROM users WHERE id = {user_id}"
cursor.execute(query)

# GOOD
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
```

**Command Injection**
```python
# BAD
os.system(f"rm {filename}")
subprocess.run(f"ls {path}", shell=True)

# GOOD
subprocess.run(["rm", filename])
subprocess.run(["ls", path])
```

**Unsafe Deserialization**
```python
# BAD - arbitrary code execution
pickle.loads(untrusted_data)
yaml.load(untrusted_data)  # without Loader

# GOOD
json.loads(untrusted_data)
yaml.safe_load(untrusted_data)
```

**Path Traversal**
```python
# BAD
path = os.path.join(base_dir, user_input)

# GOOD
path = os.path.join(base_dir, user_input)
if not os.path.realpath(path).startswith(os.path.realpath(base_dir)):
    raise ValueError("Path traversal detected")
```

**Hardcoded Secrets**
```python
# BAD
API_KEY = "sk-abc123..."
password = "admin123"

# GOOD
API_KEY = os.environ["API_KEY"]
```

## Performance Patterns

### Use Generators for Large Data
```python
# BAD - loads all into memory
def get_items():
    return [process(x) for x in huge_list]

# GOOD - lazy evaluation
def get_items():
    for x in huge_list:
        yield process(x)
```

### Avoid Repeated Attribute Lookups
```python
# BAD
for item in items:
    self.results.append(item.value)

# GOOD
results = self.results
append = results.append
for item in items:
    append(item.value)
```

### Use Sets for Membership Testing
```python
# BAD - O(n) lookup
if item in list_of_items:

# GOOD - O(1) lookup
if item in set_of_items:
```

## Common Pitfalls

- Mutable default arguments: `def f(items=[]):`
- Late binding closures in loops
- Catching bare `except:`
- Using `==` for None checks (use `is None`)
- Not using `__slots__` for data classes with many instances
- Forgetting to close resources (use context managers)

## Documentation Standards

```python
def calculate(x: float, y: float) -> float:
    """Calculate the weighted sum of x and y.

    Args:
        x: The first value.
        y: The second value.

    Returns:
        The weighted sum.

    Raises:
        ValueError: If x or y is negative.

    Examples:
        >>> calculate(1.0, 2.0)
        3.5
    """
```

## Testing with pytest

```python
import pytest

def test_function_basic():
    assert my_function(1, 2) == expected

def test_function_edge_cases():
    with pytest.raises(ValueError):
        my_function(-1, 0)

@pytest.mark.parametrize("input,expected", [
    (1, 2),
    (2, 4),
])
def test_parametrized(input, expected):
    assert double(input) == expected
```

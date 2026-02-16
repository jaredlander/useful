# C++ Code Review Reference

## Priority Focus
- Memory safety
- Modern C++ idioms (C++17/20/23)
- Performance
- RAII and resource management

## Memory Safety

### Smart Pointers
```cpp
// BAD: Raw owning pointers
Widget* w = new Widget();
// ... potential leak if exception thrown
delete w;

// GOOD: Smart pointers
auto w = std::make_unique<Widget>();  // Single ownership
auto w = std::make_shared<Widget>();  // Shared ownership
```

### Flag Raw new/delete
- `new` without immediately assigning to smart pointer
- `delete` calls (should be handled by RAII)
- `new[]` and `delete[]` (use `std::vector`)

### RAII Patterns
```cpp
// GOOD: RAII for resources
class FileHandle {
    FILE* f_;
public:
    FileHandle(const char* path) : f_(fopen(path, "r")) {
        if (!f_) throw std::runtime_error("Failed to open");
    }
    ~FileHandle() { if (f_) fclose(f_); }

    // Delete copy, implement move
    FileHandle(const FileHandle&) = delete;
    FileHandle& operator=(const FileHandle&) = delete;
    FileHandle(FileHandle&& other) noexcept : f_(other.f_) { other.f_ = nullptr; }
};
```

## Modern C++ Idioms

### Prefer
```cpp
// Range-based for loops
for (const auto& item : container) { ... }

// auto for complex types
auto it = container.find(key);
auto result = std::make_unique<ComplexType<T, U>>();

// Structured bindings (C++17)
auto [key, value] = *map.begin();
for (const auto& [k, v] : map) { ... }

// std::optional instead of pointers for optional values
std::optional<int> find_value(int key);

// std::string_view for non-owning strings
void process(std::string_view sv);

// constexpr for compile-time computation
constexpr int factorial(int n) {
    return n <= 1 ? 1 : n * factorial(n - 1);
}
```

### Avoid
```cpp
// C-style casts
int x = (int)someDouble;  // BAD
int x = static_cast<int>(someDouble);  // GOOD

// NULL (use nullptr)
Widget* w = NULL;  // BAD
Widget* w = nullptr;  // GOOD

// C-style arrays (use std::array or std::vector)
int arr[10];  // BAD
std::array<int, 10> arr;  // GOOD
```

## Performance Patterns

### Move Semantics
```cpp
// Enable move for classes with resources
class Buffer {
    std::unique_ptr<char[]> data_;
public:
    Buffer(Buffer&& other) noexcept = default;
    Buffer& operator=(Buffer&& other) noexcept = default;
};

// Use std::move for transfers
void process(std::vector<int> data);
std::vector<int> v = get_data();
process(std::move(v));  // Avoid copy
```

### Avoid Copies
```cpp
// BAD: Unnecessary copy
void process(std::vector<int> v);  // Copy on call

// GOOD: Reference for read-only
void process(const std::vector<int>& v);

// GOOD: Move for sink parameters
void store(std::vector<int> v) {
    member_ = std::move(v);
}
```

### Reserve for Vectors
```cpp
// BAD: Multiple reallocations
std::vector<int> v;
for (int i = 0; i < 10000; ++i) {
    v.push_back(i);
}

// GOOD: Pre-allocate
std::vector<int> v;
v.reserve(10000);
for (int i = 0; i < 10000; ++i) {
    v.push_back(i);
}
```

### Emplace Over Push
```cpp
// BAD: Constructs temporary
v.push_back(Widget(arg1, arg2));

// GOOD: Constructs in place
v.emplace_back(arg1, arg2);
```

## Security Checks

### Buffer Overflows
```cpp
// BAD: Unchecked array access
char buffer[100];
strcpy(buffer, user_input);  // No bounds check

// GOOD: Bounds checking
std::string buffer;
buffer = user_input;  // Safe, auto-resizes
// Or use strncpy with explicit size
```

### Integer Overflow
```cpp
// Flag arithmetic without overflow checks on untrusted input
size_t alloc_size = user_count * sizeof(Item);  // Can overflow

// GOOD: Check before arithmetic
if (user_count > SIZE_MAX / sizeof(Item)) {
    throw std::overflow_error("Size overflow");
}
```

### Format String Vulnerabilities
```cpp
// BAD: User-controlled format string
printf(user_input);

// GOOD: Fixed format
printf("%s", user_input);
// Or use streams
std::cout << user_input;
```

## Common Pitfalls

### Object Slicing
```cpp
// BAD: Slices derived class
void process(Base b);
Derived d;
process(d);  // Sliced!

// GOOD: Use reference or pointer
void process(const Base& b);
```

### Dangling References
```cpp
// BAD: Returns reference to local
const std::string& getName() {
    std::string name = compute();
    return name;  // Dangling!
}

// GOOD: Return by value
std::string getName() {
    return compute();  // RVO/move
}
```

### Virtual Destructor
```cpp
// BAD: Non-virtual destructor in base class
class Base {
public:
    ~Base() { ... }  // Should be virtual!
};

// GOOD
class Base {
public:
    virtual ~Base() = default;
};
```

## Documentation Standards

```cpp
/**
 * @brief Brief description.
 *
 * Detailed description.
 *
 * @param x Description of x
 * @return Description of return value
 * @throws std::invalid_argument if x is negative
 *
 * @note Thread-safe
 * @see related_function
 */
int calculate(int x);
```

## Testing Patterns

```cpp
// Google Test style
TEST(CalculatorTest, AddPositiveNumbers) {
    Calculator calc;
    EXPECT_EQ(calc.add(2, 3), 5);
}

TEST(CalculatorTest, ThrowsOnOverflow) {
    Calculator calc;
    EXPECT_THROW(calc.add(INT_MAX, 1), std::overflow_error);
}
```

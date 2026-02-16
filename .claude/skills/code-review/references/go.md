# Go Code Review Reference

## Priority Focus
- Error handling patterns
- Concurrency correctness
- Idiomatic Go style
- Performance

## Error Handling

### Standard Patterns
```go
// GOOD: Check errors immediately
result, err := doSomething()
if err != nil {
    return fmt.Errorf("doSomething failed: %w", err)
}

// GOOD: Wrap errors with context
if err != nil {
    return fmt.Errorf("processing user %d: %w", userID, err)
}

// Flag: Ignored errors
doSomething()  // Error ignored!
result, _ := doSomething()  // Explicitly ignored - needs justification
```

### Error Wrapping
```go
// Use %w for wrappable errors (Go 1.13+)
return fmt.Errorf("failed to connect: %w", err)

// Check wrapped errors
if errors.Is(err, ErrNotFound) { ... }

// Type assertions for error types
var netErr *net.OpError
if errors.As(err, &netErr) { ... }
```

### Custom Errors
```go
// Sentinel errors for expected conditions
var ErrNotFound = errors.New("not found")

// Custom error types for rich information
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation failed on %s: %s", e.Field, e.Message)
}
```

## Concurrency

### Goroutine Safety
```go
// Flag: Goroutine leaks
go func() {
    for {
        // No exit condition!
        process(<-ch)
    }
}()

// GOOD: Cancellable goroutine
go func() {
    for {
        select {
        case <-ctx.Done():
            return
        case item := <-ch:
            process(item)
        }
    }
}()
```

### Channel Patterns
```go
// Flag: Unbuffered channel in producer without receiver guarantee
ch := make(chan int)  // Can block forever

// Close channels from sender side
close(ch)  // Sender closes

// Range over channels
for item := range ch {
    process(item)
}
```

### Sync Primitives
```go
// Use sync.Mutex for shared state
type SafeCounter struct {
    mu    sync.Mutex
    count int
}

func (c *SafeCounter) Inc() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.count++
}

// Use sync.RWMutex for read-heavy workloads
type Cache struct {
    mu    sync.RWMutex
    items map[string]Item
}

func (c *Cache) Get(key string) (Item, bool) {
    c.mu.RLock()
    defer c.mu.RUnlock()
    item, ok := c.items[key]
    return item, ok
}
```

### Race Conditions
```go
// Flag: Shared variable without synchronization
var counter int
go func() { counter++ }()  // Race!
go func() { counter++ }()  // Race!

// Flag: Closure capturing loop variable
for _, item := range items {
    go func() {
        process(item)  // Bug: captures final value
    }()
}

// GOOD: Pass as parameter
for _, item := range items {
    go func(i Item) {
        process(i)
    }(item)
}
```

## Idiomatic Go

### Naming
```go
// Use MixedCaps, not underscores
userID, httpServer, xmlParser  // GOOD
user_id, http_server          // BAD

// Short variable names in small scopes
for i, v := range items { ... }  // OK
for index, value := range items { ... }  // Unnecessarily verbose

// Receiver names: short, consistent
func (s *Server) Start() { ... }  // Not 'self' or 'this'
```

### Interface Design
```go
// Small interfaces
type Reader interface {
    Read(p []byte) (n int, err error)
}

// Accept interfaces, return structs
func Process(r io.Reader) *Result { ... }

// Flag: Large interfaces
type DoEverything interface {
    Method1()
    Method2()
    // ... 10 more methods
}
// Better: Split into focused interfaces
```

### Struct Initialization
```go
// Use named fields for clarity
server := &Server{
    Addr:    ":8080",
    Handler: mux,
    Timeout: 30 * time.Second,
}

// Flag: Positional initialization for exported types
server := &Server{":8080", mux, 30}  // Fragile!
```

## Performance

### Slice Pre-allocation
```go
// BAD: Growing slice
var results []int
for _, item := range items {
    results = append(results, process(item))
}

// GOOD: Pre-allocate
results := make([]int, 0, len(items))
for _, item := range items {
    results = append(results, process(item))
}
```

### String Building
```go
// BAD: String concatenation in loop
var result string
for _, s := range strings {
    result += s  // O(n²)
}

// GOOD: strings.Builder
var b strings.Builder
for _, s := range strings {
    b.WriteString(s)
}
result := b.String()
```

### Avoid Allocations
```go
// Reuse buffers
var bufPool = sync.Pool{
    New: func() interface{} {
        return new(bytes.Buffer)
    },
}

func process() {
    buf := bufPool.Get().(*bytes.Buffer)
    defer bufPool.Put(buf)
    buf.Reset()
    // Use buf
}
```

## Security

### SQL Injection
```go
// BAD
query := fmt.Sprintf("SELECT * FROM users WHERE id = %s", userID)

// GOOD: Parameterized queries
db.Query("SELECT * FROM users WHERE id = ?", userID)
```

### Path Traversal
```go
// BAD
path := filepath.Join(baseDir, userInput)

// GOOD: Validate the result
path := filepath.Join(baseDir, userInput)
if !strings.HasPrefix(filepath.Clean(path), filepath.Clean(baseDir)) {
    return errors.New("path traversal detected")
}
```

## Common Pitfalls

- Defer in loops (defers until function returns)
- Nil interface vs nil concrete type
- Slice append may or may not reallocate
- Map iteration order is random
- Zero values: know what they are for each type
- Goroutine closures capturing variables

## Documentation Standards

```go
// Package config provides configuration loading and validation.
//
// The primary entry point is Load, which reads configuration from
// environment variables and config files.
package config

// Server represents an HTTP server with graceful shutdown support.
//
// Example:
//
//     srv := &Server{Addr: ":8080"}
//     if err := srv.ListenAndServe(); err != nil {
//         log.Fatal(err)
//     }
type Server struct { ... }

// Start begins listening for connections.
// It returns an error if the server is already running.
func (s *Server) Start() error { ... }
```

## Testing

```go
func TestProcess(t *testing.T) {
    tests := []struct {
        name    string
        input   int
        want    int
        wantErr bool
    }{
        {"positive", 5, 25, false},
        {"zero", 0, 0, false},
        {"negative", -1, 0, true},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := Process(tt.input)
            if (err != nil) != tt.wantErr {
                t.Errorf("Process() error = %v, wantErr %v", err, tt.wantErr)
                return
            }
            if got != tt.want {
                t.Errorf("Process() = %v, want %v", got, tt.want)
            }
        })
    }
}
```

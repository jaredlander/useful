# SQL Code Review Reference

## Priority Focus
- CTEs for readability and maintainability
- Query performance optimization
- Security (injection prevention)

## CTEs (Common Table Expressions)

### When to Use CTEs
- Breaking complex queries into logical steps
- Reusing subquery results multiple times
- Improving readability of nested queries
- Recursive queries

### Prefer CTEs Over
```sql
-- BAD: Nested subqueries
SELECT *
FROM (
    SELECT *
    FROM (
        SELECT * FROM orders WHERE status = 'active'
    ) AS active_orders
    WHERE amount > 100
) AS large_orders
WHERE date > '2024-01-01';

-- GOOD: CTE chain
WITH active_orders AS (
    SELECT * FROM orders WHERE status = 'active'
),
large_orders AS (
    SELECT * FROM active_orders WHERE amount > 100
)
SELECT * FROM large_orders WHERE date > '2024-01-01';
```

### CTE Best Practices
```sql
-- Name CTEs descriptively
WITH
    active_customers AS (...),
    customer_orders AS (...),
    order_summaries AS (...)
SELECT ...

-- Use CTEs for repeated subqueries
WITH order_totals AS (
    SELECT customer_id, SUM(amount) AS total
    FROM orders
    GROUP BY customer_id
)
SELECT
    c.name,
    ot.total,
    ot.total / (SELECT SUM(total) FROM order_totals) AS percentage
FROM customers c
JOIN order_totals ot ON c.id = ot.customer_id;
```

## Performance Optimization

### Index Usage
```sql
-- Ensure WHERE clauses use indexed columns
-- Flag: Functions on indexed columns prevent index use
-- BAD
WHERE YEAR(created_at) = 2024

-- GOOD
WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01'
```

### Avoid SELECT *
```sql
-- BAD: Fetches unnecessary columns
SELECT * FROM users WHERE id = 1;

-- GOOD: Explicit columns
SELECT id, name, email FROM users WHERE id = 1;
```

### JOIN Optimization
```sql
-- Prefer explicit JOINs over implicit
-- BAD
SELECT * FROM a, b WHERE a.id = b.a_id;

-- GOOD
SELECT * FROM a INNER JOIN b ON a.id = b.a_id;

-- Put smaller table on left for INNER JOIN
-- Filter early in JOINs
SELECT *
FROM small_table s
JOIN large_table l ON s.id = l.small_id
WHERE s.status = 'active';  -- Filters applied early
```

### Pagination
```sql
-- BAD: OFFSET for deep pagination
SELECT * FROM items ORDER BY id LIMIT 10 OFFSET 10000;

-- GOOD: Keyset pagination
SELECT * FROM items WHERE id > last_seen_id ORDER BY id LIMIT 10;
```

### Aggregation Performance
```sql
-- Use FILTER for conditional aggregates (PostgreSQL)
SELECT
    COUNT(*) AS total,
    COUNT(*) FILTER (WHERE status = 'active') AS active_count
FROM orders;

-- Avoid HAVING when WHERE works
-- BAD
SELECT customer_id, COUNT(*)
FROM orders
GROUP BY customer_id
HAVING customer_id IN (1, 2, 3);

-- GOOD
SELECT customer_id, COUNT(*)
FROM orders
WHERE customer_id IN (1, 2, 3)
GROUP BY customer_id;
```

## Security

### SQL Injection Prevention
```sql
-- NEVER concatenate user input into queries
-- Review application code that builds SQL

-- Flag dynamic SQL without parameterization
-- BAD (in application code)
query = f"SELECT * FROM users WHERE name = '{user_input}'"

-- GOOD (parameterized)
query = "SELECT * FROM users WHERE name = $1"
```

### Least Privilege
- Flag overly permissive grants
- Review GRANT statements
- Ensure roles have minimal necessary permissions

## Common Pitfalls

### NULL Handling
```sql
-- Flag: = NULL instead of IS NULL
-- BAD
WHERE column = NULL

-- GOOD
WHERE column IS NULL

-- Flag: NOT IN with NULLs
-- BAD (returns no rows if subquery has NULL)
WHERE id NOT IN (SELECT nullable_col FROM other_table)

-- GOOD
WHERE id NOT IN (SELECT nullable_col FROM other_table WHERE nullable_col IS NOT NULL)
-- OR use NOT EXISTS
```

### DISTINCT Overuse
```sql
-- Flag: DISTINCT hiding JOIN issues
-- BAD: Masks duplicate problem
SELECT DISTINCT a.* FROM a JOIN b ON ...

-- GOOD: Fix the JOIN or use appropriate aggregate
```

### Implicit Type Conversion
```sql
-- Flag: Type mismatches in comparisons
-- BAD (if user_id is INT)
WHERE user_id = '123'

-- GOOD
WHERE user_id = 123
```

## Query Structure Standards

```sql
-- Consistent formatting
SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS order_count,
    SUM(o.amount) AS total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE c.status = 'active'
    AND o.created_at >= '2024-01-01'
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 5
ORDER BY total_amount DESC
LIMIT 100;
```

## Database-Specific Notes

Flag usage that's specific to one database when portability matters:
- `LIMIT` vs `TOP` vs `FETCH FIRST`
- `ILIKE` (PostgreSQL) vs `LIKE` with `LOWER()`
- Array operations
- JSON functions
- Window function syntax variations

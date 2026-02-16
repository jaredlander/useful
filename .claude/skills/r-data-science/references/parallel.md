# Parallel Computing with crew and mirai

## Contents
1. [Overview](#overview)
2. [mirai: Async Tasks](#mirai-async-tasks)
3. [crew: Worker Pools](#crew-worker-pools)
4. [Integration with targets](#integration-with-targets)
5. [Common Patterns](#common-patterns)

---

## Overview

**mirai** provides minimalist async evaluation - launch tasks and collect results.

**crew** builds on mirai to provide managed worker pools with auto-scaling, ideal for:
- targets pipelines
- Shiny apps
- Batch processing

Hierarchy: `crew` → uses → `mirai` → uses → `nanonext` (C bindings)

---

## mirai: Async Tasks

### Basic Usage
```r
library(mirai)

# Launch async task
m <- mirai({
  Sys.sleep(2)
  expensive_computation(x)
}, x = my_data)

# Check status
unresolved(m)  # TRUE while running

# Collect result (blocks if not ready)
result <- m$data

# Or use call_mirai() to block explicitly
result <- call_mirai(m)$data
```

### Multiple Tasks
```r
# Launch many tasks
tasks <- lapply(data_chunks, function(chunk) {

  mirai({
    process_chunk(chunk)
  }, chunk = chunk)
})

# Collect all results
results <- lapply(tasks, \(m) m$data)
```

### With Daemons (Persistent Workers)
```r
# Start worker pool
daemons(n = 4)

# Now mirai() dispatches to workers
results <- lapply(1:100, function(i) {

  mirai({ slow_function(i) }, i = i)
})

# Collect
output <- lapply(results, \(m) m$data)

# Cleanup
daemons(0)
```

### Async with Promises (Shiny)
```r
library(mirai)
library(promises)

# In Shiny server
observeEvent(input$run, {
  m <- mirai({ long_computation() })
  
  # Non-blocking - UI stays responsive
  promises::as.promise(m) %...>% {
    output$result <- renderText(.)
  }
})
```

---

## crew: Worker Pools

### Local Workers
```r
library(crew)

# Create controller
controller <- crew_controller_local(
  workers = 4,
 seconds_idle = 10  # Shut down idle workers
)

# Start
controller$start()

# Push tasks
controller$push(
  command = slow_function(x),
  data = list(x = my_data),
  name = "task1"
)

# Pop completed results
controller$pop()  # Returns one result or NULL
controller$collect()  # Blocks until all complete

# Cleanup
controller$terminate()
```

### Batch Processing Pattern
```r
library(crew)

controller <- crew_controller_local(workers = 4)
controller$start()

# Push all tasks
for (i in seq_along(data_list)) {
  controller$push(
    command = process(item),
    data = list(item = data_list[[i]]),
    name = paste0("task_", i)
  )
}

# Collect results as they complete
results <- list()
while (!controller$empty()) {
  result <- controller$pop()
  if (!is.null(result)) {
    results[[result$name]] <- result$result
  }
  Sys.sleep(0.1)  # Avoid busy-waiting
}

controller$terminate()
```

### Map Pattern
```r
library(crew)

# crew_map: like lapply but parallel
results <- crew_map(
  x = data_chunks,
  fun = process_chunk,
  controller = crew_controller_local(workers = 4)
)
```

### Cluster Workers (HPC)
```r
library(crew.cluster)

# SLURM
controller <- crew_controller_slurm(
  workers = 20,
  seconds_idle = 120,
  slurm_memory_gigabytes_per_cpu = 8,
  slurm_cpus_per_task = 1,
  slurm_time_minutes = 60,
  slurm_partition = "standard"
)

# PBS/Torque
controller <- crew_controller_pbs(
  workers = 10,
  pbs_walltime_hours = 2,
  pbs_memory_gigabytes = 16
)

# SGE
controller <- crew_controller_sge(
  workers = 10,
  sge_memory_gigabytes = 8
)
```

### AWS Batch
```r
library(crew.aws.batch)

controller <- crew_controller_aws_batch(
  workers = 50,
  aws_batch_job_queue = "my-queue",
  aws_batch_job_definition = "my-definition",
  seconds_idle = 300
)
```

---

## Integration with targets

### Basic Setup
```r
# _targets.R
library(targets)
library(crew)

tar_option_set(
  controller = crew_controller_local(workers = 4)
)

list(
  tar_target(data, load_data()),
  tar_target(result, process(data))  # Runs in parallel worker
)
```

### Multiple Controller Groups
```r
# _targets.R
library(targets)
library(crew)

# Different resources for different tasks
tar_option_set(
  controller = crew_controller_group(
    crew_controller_local(name = "small", workers = 4),
    crew_controller_local(name = "large", workers = 2)
  )
)

list(
  tar_target(quick_task, fast_fn(x), resources = tar_resources(
    crew = tar_resources_crew(controller = "small")
  )),
  tar_target(heavy_task, slow_fn(y), resources = tar_resources(
    crew = tar_resources_crew(controller = "large")
  ))
)
```

### HPC with targets
```r
# _targets.R
library(targets)
library(crew.cluster)

tar_option_set(
  controller = crew_controller_slurm(
    workers = 100,
    slurm_memory_gigabytes_per_cpu = 4,
    slurm_cpus_per_task = 1,
    seconds_idle = 120
  )
)
```

---

## Common Patterns

### Progress Tracking
```r
library(crew)

controller <- crew_controller_local(workers = 4)
controller$start()

n_tasks <- 100
for (i in 1:n_tasks) {
  controller$push(command = slow_fn(i), data = list(i = i))
}

completed <- 0
results <- list()
while (!controller$empty()) {
  result <- controller$pop()
  if (!is.null(result)) {
    completed <- completed + 1
    results[[completed]] <- result$result
    cat(sprintf("\rProgress: %d/%d", completed, n_tasks))
  }
  Sys.sleep(0.05)
}

controller$terminate()
```

### Error Handling
```r
controller$push(
  command = {
    tryCatch(
      risky_function(x),
      error = function(e) list(error = conditionMessage(e))
    )
  },
  data = list(x = input)
)

result <- controller$pop()
if (inherits(result$result, "list") && !is.null(result$result$error)) {
  warning("Task failed: ", result$result$error)
}
```

### Throttling
```r
# Limit concurrent tasks
max_concurrent <- 10

while (length(pending_tasks) > 0 || !controller$empty()) {
  # Push new tasks if under limit
  while (controller$unpopped() < max_concurrent && length(pending_tasks) > 0) {
    task <- pending_tasks[[1]]
    pending_tasks <- pending_tasks[-1]
    controller$push(command = process(task), data = list(task = task))
  }
  
  # Collect completed
  result <- controller$pop()
  if (!is.null(result)) {
    # Process result
  }
  
  Sys.sleep(0.1)
}
```

### Memory-Conscious Chunking
```r
library(crew)

# Process large data in chunks to limit memory
chunk_size <- 10000
n_rows <- nrow(big_data)
chunks <- split(seq_len(n_rows), ceiling(seq_len(n_rows) / chunk_size))

controller <- crew_controller_local(workers = 4)
controller$start()

for (idx in chunks) {
  chunk <- big_data[idx, ]
  controller$push(
    command = process_chunk(chunk),
    data = list(chunk = chunk)
  )
}

results <- controller$collect()
controller$terminate()

# Combine
final <- bind_rows(lapply(results, \(r) r$result))
```

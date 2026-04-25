# 0021 - Concurrency and Tasks

## Goal

Use Lean's Task system for concurrent programming. Understand how Lean
handles parallelism in a pure functional setting.

## Tasks (Lightweight Threads)

```lean fromFile:Examples.lean#spawn_task
-- Spawn a task
def main : IO Unit := do
  let task <- IO.asTask (prio := .default) do
    IO.sleep 1000
    return 42
  -- Do other work...
  let result <- IO.wait task
  IO.println s!"Result: {result}"
```

## Parallel Map

```lean fromFile:Examples.lean#parallel_map
def parallelMap {alpha beta : Type} (f : alpha -> IO beta)
    (xs : Array alpha) : IO (Array beta) := do
  let tasks <- xs.mapM fun x => IO.asTask (f x)
  tasks.mapM fun t => do
    let result <- IO.wait t
    match result with
    | .ok v => pure v
    | .error e => throw e
```

## BaseIO vs IO

- `IO` can throw exceptions
- `BaseIO` is the base monad without exceptions
- `EIO` is IO parameterized by error type

```lean
-- Task types
-- Task alpha : a computation that will produce an alpha
-- IO.asTask : IO alpha -> IO (Task (Except IO.Error alpha))
```

## Mutex and MVar

```lean
-- IO.Mutex for mutual exclusion
def counterExample : IO Unit := do
  let mutex <- IO.Mutex.new 0
  let tasks <- (List.range 100).toArray.mapM fun _ =>
    IO.asTask do
      mutex.atomically do
        let n <- get
        set (n + 1)
  for t in tasks do
    let _ <- IO.wait t
  let final <- mutex.atomically get
  IO.println s!"Counter: {final}"  -- 100
```

## IO.Ref (Mutable References)

```lean fromFile:Examples.lean#io_ref
def refExample : IO Unit := do
  let ref <- IO.mkRef (0 : Nat)
  ref.modify (. + 1)
  ref.modify (. + 1)
  let val <- ref.get
  IO.println s!"Value: {val}"  -- 2
```

## Channels (IO.Channel)

```lean
-- Producer-consumer pattern
def channelExample : IO Unit := do
  let chan <- IO.Channel.new
  -- Producer
  let _ <- IO.asTask do
    for i in List.range 10 do
      chan.send i
  -- Consumer
  for _ in List.range 10 do
    let val <- chan.recv
    IO.println s!"Got: {val}"
```

## Use Cases

- Parallel file processing
- Concurrent network requests
- Background computation while waiting for IO
- Pipeline processing with channels

/-
# 0021 - Concurrency and Tasks Exercises
-/

-- Exercise 1: Spawn a task that computes fibonacci(30)
-- and print the result
def ex1_fibTask : IO Unit := do
  sorry

-- Exercise 2: Parallel map
-- Apply a function to each element of an array in parallel
def parallelMap (f : alpha -> IO beta) (xs : Array alpha) :
    IO (Array beta) := do
  sorry

-- Exercise 3: Use IO.Ref to implement a mutable counter
-- Increment it 1000 times and print the result
def ex3_counter : IO Unit := do
  sorry

-- Exercise 4: Concurrent file reader
-- Given a list of file paths, read them all in parallel
-- and return the concatenated contents
def readAllParallel (paths : Array String) : IO String := do
  sorry

-- Exercise 5: Implement a simple timeout mechanism
-- Run an IO action with a timeout (in milliseconds)
-- Return none if the action takes too long
def withTimeout (ms : Nat) (action : IO alpha) :
    IO (Option alpha) := do
  sorry

-- Exercise 6: Fan-out / fan-in
-- Spawn N tasks, each computing a partial result
-- Collect all results and combine them
def fanOutFanIn (n : Nat) (compute : Nat -> IO Nat)
    (combine : Array Nat -> Nat) : IO Nat := do
  sorry

-- Exercise 7: Implement a simple producer-consumer
-- Producer generates numbers 1..n
-- Consumer sums them up
-- Use IO.Ref or similar for communication
def producerConsumer (n : Nat) : IO Nat := do
  sorry

/-
# 0021 - Concurrency and Tasks Solutions
-/

def fib : Nat -> Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => fib (n + 1) + fib n

-- Exercise 1
def ex1_fibTask : IO Unit := do
  let task <- IO.asTask (fun _ => pure (fib 30))
  let result <- IO.wait task
  match result with
  | .ok n => IO.println s!"fib(30) = {n}"
  | .error e => IO.eprintln s!"Error: {e}"

-- Exercise 2
def parallelMap (f : alpha -> IO beta) (xs : Array alpha) :
    IO (Array beta) := do
  let tasks <- xs.mapM fun x => IO.asTask (f x)
  let mut results := #[]
  for t in tasks do
    let r <- IO.wait t
    match r with
    | .ok v => results := results.push v
    | .error e => throw e
  return results

-- Exercise 3
def ex3_counter : IO Unit := do
  let ref <- IO.mkRef (0 : Nat)
  for _ in List.range 1000 do
    ref.modify (. + 1)
  let val <- ref.get
  IO.println s!"Counter: {val}"

-- Exercise 4
def readAllParallel (paths : Array String) : IO String := do
  let contents <- parallelMap IO.FS.readFile paths
  return contents.foldl (. ++ .) ""

-- Exercise 5
def withTimeout (ms : Nat) (action : IO alpha) :
    IO (Option alpha) := do
  let task <- IO.asTask action
  IO.sleep ms.toUInt32
  -- Note: Lean does not have native task cancellation,
  -- so this is a simplified version
  let result <- IO.wait task
  match result with
  | .ok v => return some v
  | .error _ => return none

-- Exercise 6
def fanOutFanIn (n : Nat) (compute : Nat -> IO Nat)
    (combine : Array Nat -> Nat) : IO Nat := do
  let tasks <- (Array.range n).mapM fun i =>
    IO.asTask (compute i)
  let mut results := #[]
  for t in tasks do
    let r <- IO.wait t
    match r with
    | .ok v => results := results.push v
    | .error e => throw e
  return combine results

-- Exercise 7
def producerConsumer (n : Nat) : IO Nat := do
  let ref <- IO.mkRef (0 : Nat)
  for i in List.range n do
    ref.modify (. + (i + 1))
  ref.get

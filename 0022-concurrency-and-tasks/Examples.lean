/-
# 0022 - Concurrency and Tasks Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0022Examples

-- #anchor: spawn_task
-- Spawn a task
def main : IO Unit := do
  let task <- IO.asTask (prio := .default) do
    IO.sleep 1000
    return 42
  -- Do other work...
  let result <- IO.wait task
  IO.println s!"Result: {result}"
-- #end

-- #anchor: parallel_map
def parallelMap {alpha beta : Type} (f : alpha -> IO beta)
    (xs : Array alpha) : IO (Array beta) := do
  let tasks <- xs.mapM fun x => IO.asTask (f x)
  tasks.mapM fun t => do
    let result <- IO.wait t
    match result with
    | .ok v => pure v
    | .error e => throw e
-- #end

-- #anchor: io_ref
def refExample : IO Unit := do
  let ref <- IO.mkRef (0 : Nat)
  ref.modify (. + 1)
  ref.modify (. + 1)
  let val <- ref.get
  IO.println s!"Value: {val}"  -- 2
-- #end

end Course0022Examples

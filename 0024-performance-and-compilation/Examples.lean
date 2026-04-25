/-
# 0024 - Performance and Compilation Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0024Examples

-- #anchor: reference_counting
-- This is efficient: if xs has refcount 1, the push mutates in-place
def appendMany (xs : Array Nat) (n : Nat) : Array Nat := Id.run do
  let mut arr := xs
  for i in List.range n do
    arr := arr.push i
  return arr
-- #end

-- #anchor: tail_recursion
-- Not tail recursive (stack overflow on large n)
def sumBad : Nat -> Nat
  | 0 => 0
  | n + 1 => (n + 1) + sumBad n

-- Tail recursive (constant stack)
def sumGood (n : Nat) : Nat :=
  go n 0
where
  go : Nat -> Nat -> Nat
    | 0, acc => acc
    | n + 1, acc => go n (acc + n + 1)
-- #end

-- #anchor: inline_and_specialize
-- Force inlining
@[inline]
def myAdd (a b : Nat) : Nat := a + b

-- Specialize generic functions for specific types
@[specialize]
def myMap {alpha beta : Type} (f : alpha -> beta) :
    List alpha -> List beta
  | [] => []
  | x :: xs => f x :: myMap f xs
-- #end

-- #anchor: benchmarking
def benchmark (label : String) (action : IO Unit) : IO Unit := do
  let start <- IO.monoMsNow
  action
  let elapsed <- IO.monoMsNow
  IO.println s!"{label}: {elapsed - start}ms"
-- #end

-- #anchor: implemented_by
-- Specification (for proofs)
def slowFib : Nat -> Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => slowFib (n + 1) + slowFib n

-- Efficient implementation (for execution)
private def fastFibImpl (n : Nat) : Nat :=
  go n 0 1
where
  go : Nat -> Nat -> Nat -> Nat
    | 0, a, _ => a
    | n + 1, a, b => go n b (a + b)

@[implemented_by fastFibImpl]
def fib : Nat -> Nat := slowFib
-- #end

end Course0024Examples

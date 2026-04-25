# 0023 - Performance and Compilation

## Goal

Understand Lean's compilation model, performance characteristics, and
optimization techniques. Write efficient Lean code.

## Lean's Compilation Pipeline

```
Lean source
  -> Elaboration (type checking)
  -> Lean IR (intermediate representation)
  -> C code generation
  -> C compiler (clang/gcc)
  -> Native binary
```

## Reference Counting

Lean uses reference counting (not garbage collection):

- Each object has a reference count
- When count reaches 0, object is freed immediately
- Destructive updates are free when refcount = 1

```lean fromFile:Examples.lean#reference_counting
-- This is efficient: if xs has refcount 1, the push mutates in-place
def appendMany (xs : Array Nat) (n : Nat) : Array Nat := Id.run do
  let mut arr := xs
  for i in List.range n do
    arr := arr.push i
  return arr
```

## Array vs List Performance

| Operation | Array | List |
|-----------|-------|------|
| Index access | O(1) | O(n) |
| Push back | O(1) amortized | O(n) |
| Cons (prepend) | O(n) | O(1) |
| Size | O(1) | O(n) |
| Map | O(n) | O(n) |

**Rule of thumb**: use `Array` for mutable-style code, `List` for
pattern matching and recursion.

## Tail Recursion

Lean optimizes tail calls:

```lean fromFile:Examples.lean#tail_recursion
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
```

## Unboxed Types

Lean unboxes small scalar types for performance:

```lean
-- UInt32, UInt64, Float are stored unboxed (no heap allocation)
-- Nat, Int are arbitrary-precision (heap-allocated for large values)
```

Use `UInt32`/`UInt64` for performance-critical numeric code.

## @[inline] and @[specialize]

```lean fromFile:Examples.lean#inline_and_specialize
-- Force inlining
@[inline]
def myAdd (a b : Nat) : Nat := a + b

-- Specialize generic functions for specific types
@[specialize]
def myMap {alpha beta : Type} (f : alpha -> beta) :
    List alpha -> List beta
  | [] => []
  | x :: xs => f x :: myMap f xs
```

## Benchmarking

```lean fromFile:Examples.lean#benchmarking
def benchmark (label : String) (action : IO Unit) : IO Unit := do
  let start <- IO.monoMsNow
  action
  let elapsed <- IO.monoMsNow
  IO.println s!"{label}: {elapsed - start}ms"
```

## @[implementedBy]

Provide an optimized implementation for a definition used in proofs:

```lean fromFile:Examples.lean#implemented_by
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
```

## Compiler Options

```lean
-- In lakefile.lean
set_option compiler.extract_closed false  -- Debug
```

```bash
lake build -KreleaseBuild  -- Release mode
```

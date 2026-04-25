# 0007 - Monads and Do Notation

## Goal

Understand monads as a pattern for sequencing computations. Learn do-notation
for readable monadic code.

## The Problem Monads Solve

Many computations follow a pattern: "do X, then use the result to do Y,
then use that result to do Z". But the details vary:

- **Option**: any step might fail (return `none`)
- **Except**: any step might produce an error
- **IO**: steps have side effects
- **List**: steps produce multiple results

## Option as a Monad

```lean fromFile:Examples.lean#option_monad
def safeDivide (a b : Nat) : Option Nat :=
  if b == 0 then none else some (a / b)

-- Without do-notation (explicit bind)
def computation : Option Nat :=
  safeDivide 10 2 >>= fun x =>
  safeDivide x 0 >>= fun y =>
  some (y + 1)

-- With do-notation (much cleaner)
def computation' : Option Nat := do
  let x <- safeDivide 10 2
  let y <- safeDivide x 0
  return y + 1

#eval computation'  -- none (division by zero in second step)
```

## The Monad Typeclass

```lean fromFile:Examples.lean#monad_typeclass
-- Simplified definition (actual one is more general)
class MyMonad (m : Type -> Type) where
  pure : alpha -> m alpha           -- wrap a value
  bind : m alpha -> (alpha -> m beta) -> m beta  -- sequence
```

- `pure` (or `return`): wrap a plain value
- `bind` (or `>>=`): chain computations

## Do-Notation Translation

```lean fromFile:Examples.lean#do_notation_translation
-- This:
-- do
--   let x <- action1
--   let y <- action2 x
--   return f x y
--
-- Desugars to:
-- action1 >>= fun x =>
-- action2 x >>= fun y =>
-- pure (f x y)
```

## IO Monad

IO is the monad for side effects:

```lean fromFile:Examples.lean#io_monad
def main : IO Unit := do
  let name <- IO.getStdin >>= fun stdin => stdin.getLine
  IO.println s!"Hello, {name.trimAscii}!"
```

## Except Monad (Error Handling)

```lean fromFile:Examples.lean#except_monad
def parseInt (s : String) : Except String Int :=
  match s.toInt? with
  | some n => .ok n
  | none => .error s!"Not a number: {s}"

def addStrings (a b : String) : Except String Int := do
  let x <- parseInt a
  let y <- parseInt b
  return x + y

#eval addStrings "3" "4"      -- Except.ok 7
#eval addStrings "3" "hello"  -- Except.error "Not a number: hello"
```

## Math Track: Kleisli Composition

A monad is an endofunctor with two natural transformations (unit and
multiplication) satisfying associativity and unit laws. In Lean terms:

- `pure` is the unit (eta)
- `bind` gives you Kleisli composition
- The monad laws ensure associativity of this composition

## CS Track: Effectful Programming

Monads let you write code that looks imperative (sequential, with
variables) while remaining purely functional under the hood. The `do`
block is syntactic sugar that compiles to function composition.

/-
# 0007 - Monads and Do Notation Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0007Examples

-- #anchor: option_monad
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
-- #end

-- #anchor: monad_typeclass
-- Simplified definition (actual one is more general)
class MyMonad (m : Type -> Type) where
  pure : alpha -> m alpha           -- wrap a value
  bind : m alpha -> (alpha -> m beta) -> m beta  -- sequence
-- #end

-- #anchor: do_notation_translation
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
-- #end

-- #anchor: io_monad
def main : IO Unit := do
  let name <- IO.getStdin >>= fun stdin => stdin.getLine
  IO.println s!"Hello, {name.trimAscii}!"
-- #end

-- #anchor: except_monad
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
-- #end

end Course0007Examples

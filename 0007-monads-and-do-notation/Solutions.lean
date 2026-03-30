/-
# 0007 - Monads and Do Notation Solutions
-/

namespace Course0007

-- Exercise 1
def safeHead {alpha : Type} (xs : List alpha) : Option alpha :=
  match xs with
  | [] => none
  | x :: _ => some x

-- Exercise 2
def headOfHead {alpha : Type} (xss : List (List alpha)) :
    Option alpha := do
  let first <- safeHead xss
  safeHead first

-- Exercise 3
def safeIndex {alpha : Type} (xs : List alpha) (i : Nat) :
    Option alpha :=
  match xs, i with
  | [], _ => none
  | x :: _, 0 => some x
  | _ :: tail, n + 1 => safeIndex tail n

-- Exercise 4
def doubleIndex (xs ys : List Nat) (i : Nat) : Option Nat := do
  let j <- safeIndex xs i
  safeIndex ys j

-- Exercise 5
def safeSqrt (n : Float) : Except String Float :=
  if n < 0.0 then .error "negative input" else .ok (Float.sqrt n)

def doubleSqrt (n : Float) : Except String Float := do
  let x <- safeSqrt n
  safeSqrt x

-- Exercise 6
def sumStrings (strs : List String) : Except String Int := do
  let mut total : Int := 0
  for s in strs do
    match s.toInt? with
    | some n => total := total + n
    | none => throw s!"Not a number: {s}"
  return total

-- Exercise 7
structure Id (alpha : Type) where
  val : alpha

instance : Monad Id where
  pure x := { val := x }
  bind ma f := f ma.val

-- Exercise 8 (IO, kept as definition but not evaluated)
def greet (name : String) : IO Unit := do
  IO.println s!"Hello, {name}!"
  IO.println "Welcome to Lean 4."
  IO.println "Have fun!"

end Course0007

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

-- ============================================================
-- Additional Exercises
-- ============================================================

-- Exercise 9 (medium): mapM for List
def mapM' {m : Type -> Type} [Monad m] {alpha beta : Type}
    (f : alpha -> m beta) : List alpha -> m (List beta)
  | [] => pure []
  | x :: xs => do
    let y <- f x
    let ys <- mapM' f xs
    pure (y :: ys)

#eval mapM' (fun n => if n > 0 then some n else none) [1, 2, 3]
-- some [1, 2, 3]
#eval mapM' (fun n => if n > 0 then some n else none) [1, 0, 3]
-- none

-- Exercise 10 (hard): State monad from scratch
structure MyState (s : Type) (alpha : Type) where
  run : s -> alpha × s

instance {s : Type} : Monad (MyState s) where
  pure x := { run := fun s => (x, s) }
  bind ma f := {
    run := fun s =>
      let (a, s') := ma.run s
      (f a).run s'
  }

def myGet {s : Type} : MyState s s :=
  { run := fun s => (s, s) }

def mySet {s : Type} (newState : s) : MyState s Unit :=
  { run := fun _ => ((), newState) }

-- Exercise 11 (hard): Counter using State monad
def countItems {alpha : Type} (xs : List alpha) : Nat :=
  let counter : MyState Nat Unit := do
    for _ in xs do
      let n <- myGet
      mySet (n + 1)
  (counter.run 0).2

#eval countItems [10, 20, 30, 40]  -- 4

-- Exercise 12 (challenge): Writer monad
structure Writer (w : Type) (alpha : Type) where
  run : alpha × w

def tell (msg : String) : Writer (List String) Unit :=
  { run := ((), [msg]) }

instance : Monad (Writer (List String)) where
  pure x := { run := (x, []) }
  bind ma f :=
    let (a, w1) := ma.run
    let (b, w2) := (f a).run
    { run := (b, w1 ++ w2) }

def loggedAdd (a b : Nat) : Writer (List String) Nat := do
  tell s!"Adding {a} and {b}"
  let result := a + b
  tell s!"Result is {result}"
  pure result

#eval (loggedAdd 3 4).run  -- (7, ["Adding 3 and 4", "Result is 7"])

end Course0007

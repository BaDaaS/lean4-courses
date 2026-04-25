/-
# 0002 - Functions Examples

Runnable examples from the README, anchored for documentation.
-/

namespace Course0002Examples

-- #anchor: defining_functions
-- Named definition
def add (a b : Nat) : Nat := a + b

-- Lambda (anonymous function)
def add' : Nat -> Nat -> Nat := fun a b => a + b

-- With pattern matching
def isEven : Nat -> Bool
  | 0 => true
  | 1 => false
  | n + 2 => isEven n
-- #end

-- #anchor: beta_reduction
-- (fun x => x + 1) 3   computes to   3 + 1   computes to   4
#eval (fun x => x + 1) 3    -- 4
-- #end

-- #anchor: eta_reduction
-- These are definitionally equal
example : (fun x => Nat.succ x) = Nat.succ := rfl
-- #end

-- #anchor: currying_partial_application
-- These are the same type:
-- Nat -> Nat -> Nat
-- Nat -> (Nat -> Nat)

def add3 := add 3  -- partial application: Nat -> Nat
#eval add3 7        -- 10
-- #end

-- #anchor: list_length
def listLength {alpha : Type} (xs : List alpha) : Nat :=
  match xs with
  | [] => 0
  | _ :: tail => 1 + listLength tail

#eval listLength [1, 2, 3]  -- Lean infers alpha = Nat
-- #end

-- #anchor: list_length_explicit
#eval @listLength Nat [1, 2, 3]
-- #end

-- #anchor: instance_implicit
def printIt {alpha : Type} [ToString alpha] (x : alpha) : String :=
  toString x
-- #end

-- #anchor: where_clause
def hypotenuse (a b : Float) : Float :=
  Float.sqrt (sq a + sq b)
where
  sq (x : Float) := x * x
-- #end

-- #anchor: let_clause
def hypotenuse' (a b : Float) : Float :=
  let sq (x : Float) := x * x
  Float.sqrt (sq a + sq b)
-- #end

-- #anchor: higher_order_functions
-- Takes a function as argument
def applyTwice {alpha : Type} (f : alpha -> alpha) (x : alpha) : alpha :=
  f (f x)

#eval applyTwice (fun n : Nat => n + 1) 0  -- 2

-- Returns a function
def adder (n : Nat) : Nat -> Nat :=
  fun m => n + m

#eval adder 3 7  -- 10
-- #end

-- #anchor: compose
def compose {alpha beta gamma : Type}
    (f : beta -> gamma) (g : alpha -> beta) :
    alpha -> gamma :=
  fun x => f (g x)
-- #end

end Course0002Examples

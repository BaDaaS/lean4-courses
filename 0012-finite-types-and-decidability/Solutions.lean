/-
# 0012 - Finite Types and Decidability Solutions
-/

namespace Course0012

universe u

-- Exercise 1
#eval decide (2 + 2 = 4)    -- true
#eval decide (2 + 2 = 5)    -- false

-- Exercise 2
def safeHead {alpha : Type u} (xs : List alpha)
    (h : xs.length > 0) : alpha :=
  match xs, h with
  | x :: _, _ => x

-- Exercise 3
def allFin4 : List (Fin 4) := [0, 1, 2, 3]

-- Exercise 4
def finToNat {n : Nat} (i : Fin n) : Nat := i.val

-- Exercise 5
def listNatDecEq (xs ys : List Nat) : Decidable (xs = ys) :=
  inferInstance

-- Exercise 6
def evenOrOdd (n : Nat) : String :=
  if n % 2 = 0 then "yes" else "no"

-- Exercise 7
theorem fin_zero_empty : Fin 0 -> False :=
  fun i => Nat.not_lt_zero i.val i.isLt

-- Exercise 8
def fin3ToString : Fin 3 -> String
  | 0 => "zero"
  | 1 => "one"
  | 2 => "two"

end Course0012

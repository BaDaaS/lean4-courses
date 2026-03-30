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

-- Exercise 9 (medium): Count elements satisfying a decidable predicate
def countIf {alpha : Type u} (p : alpha -> Prop)
    [DecidablePred p] (xs : List alpha) : Nat :=
  xs.foldl (fun acc x => if p x then acc + 1 else acc) 0

#eval countIf (fun n : Nat => n > 3) [1, 2, 5, 8, 3]  -- 2

-- Exercise 10 (hard): Decidable conjunction, constructed manually
def decidableAnd (P Q : Prop) [dp : Decidable P]
    [dq : Decidable Q] : Decidable (P /\ Q) :=
  match dp, dq with
  | isTrue hp, isTrue hq => isTrue (And.intro hp hq)
  | isFalse hp, _ => isFalse (fun h => hp h.1)
  | _, isFalse hq => isFalse (fun h => hq h.2)

-- Exercise 11 (hard): Bounded search
def boundedSearch (p : Nat -> Prop) [DecidablePred p]
    (bound : Nat) : Option Nat :=
  go 0
where
  go (i : Nat) : Option Nat :=
    if i >= bound then none
    else if p i then some i
    else go (i + 1)
  termination_by bound - i

-- Exercise 12 (challenge): Decidable equality on List Nat, manually
def listNatDecEqManual :
    (xs ys : List Nat) -> Decidable (xs = ys)
  | [], [] => isTrue rfl
  | [], _ :: _ => isFalse (fun h => by cases h)
  | _ :: _, [] => isFalse (fun h => by cases h)
  | x :: xs, y :: ys =>
    if hxy : x = y then
      match listNatDecEqManual xs ys with
      | isTrue htl => isTrue (by rw [hxy, htl])
      | isFalse htl =>
        isFalse (fun h => by cases h; exact htl rfl)
    else
      isFalse (fun h => by cases h; exact hxy rfl)

end Course0012

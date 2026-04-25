/-
# 0008 - Pattern Matching and Recursion Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0008Examples

-- #anchor: basic_matching
def describe : Nat -> String
  | 0 => "zero"
  | 1 => "one"
  | _ => "many"
-- #end

-- #anchor: nested_patterns
def firstTwo {alpha : Type} : List alpha -> Option (alpha × alpha)
  | a :: b :: _ => some (a, b)
  | _           => none
-- #end

-- #anchor: multiple_discriminants
def zip {alpha : Type} {beta : Type} :
    List alpha -> List beta -> List (alpha × beta)
  | a :: as, b :: bs => (a, b) :: zip as bs
  | _, _ => []
-- #end

-- #anchor: factorial
-- Lean accepts this: n is structurally smaller than n + 1
def factorial : Nat -> Nat
  | 0     => 1
  | n + 1 => (n + 1) * factorial n
-- #end

-- #anchor: gcd_termination
def gcd (a b : Nat) : Nat :=
  if b == 0 then a
  else gcd b (a % b)
termination_by b
decreasing_by
  rename_i h
  simp [beq_iff_eq] at h
  exact Nat.mod_lt a (Nat.pos_of_ne_zero h)
-- #end

-- #anchor: mutual_recursion
mutual
  def isEven : Nat -> Bool
    | 0     => true
    | n + 1 => isOdd n

  def isOdd : Nat -> Bool
    | 0     => false
    | n + 1 => isEven n
end
-- #end

end Course0008Examples

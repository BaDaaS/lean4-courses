/-
# 0010 - Natural Numbers and Induction Solutions
-/

namespace Course0010

universe u

-- Exercise 1
theorem zero_add (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ n ih => rw [Nat.add_succ, ih]

-- Exercise 2
theorem add_zero (n : Nat) : n + 0 = n := by
  rfl  -- definitional for Nat

-- Exercise 3
theorem succ_add (n m : Nat) : (n + 1) + m = (n + m) + 1 := by
  omega

-- Exercise 4
theorem add_comm (n m : Nat) : n + m = m + n := by
  omega

-- Exercise 5
theorem add_assoc (n m k : Nat) : (n + m) + k = n + (m + k) := by
  omega

-- Exercise 6
theorem zero_mul (n : Nat) : 0 * n = 0 := by
  induction n with
  | zero => rfl
  | succ n ih => simp [Nat.mul_succ, ih]

-- Exercise 7
theorem mul_zero (n : Nat) : n * 0 = 0 := by
  rfl

-- Exercise 8
def sumTo : Nat -> Nat
  | 0 => 0
  | n + 1 => (n + 1) + sumTo n

theorem gauss_formula (n : Nat) : 2 * sumTo n = n * (n + 1) := by
  induction n with
  | zero => rfl
  | succ n ih =>
    unfold sumTo
    rw [Nat.mul_add, ih, <- Nat.add_mul, Nat.add_comm 2 n,
        Nat.mul_comm]

-- Exercise 9
theorem length_append {alpha : Type u} (xs ys : List alpha) :
    (xs ++ ys).length = xs.length + ys.length := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp [ih]; omega

-- ============================================================
-- Additional Exercises
-- ============================================================

-- Exercise 10 (medium)
theorem add_succ' (n m : Nat) : n + (m + 1) = (n + m) + 1 := by
  omega

-- Exercise 11 (hard): mul distributes over add
theorem mul_add' (a b c : Nat) :
    a * (b + c) = a * b + a * c := by
  induction c with
  | zero => simp
  | succ c ih =>
    rw [Nat.add_succ, Nat.mul_succ, Nat.mul_succ, ih]
    omega

-- Exercise 12 (hard): power law
theorem pow_add' (a b c : Nat) :
    a ^ (b + c) = a ^ b * a ^ c := by
  induction c with
  | zero => simp
  | succ c ih =>
    rw [Nat.add_succ, Nat.pow_succ, Nat.pow_succ, ih]
    simp [Nat.mul_assoc]

-- Exercise 13 (challenge): sum of first n odd numbers = n^2
def sumOdds : Nat -> Nat
  | 0 => 0
  | n + 1 => (2 * n + 1) + sumOdds n

theorem sum_odds_eq_sq (n : Nat) : sumOdds n = n ^ 2 := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [sumOdds, ih]
    simp [Nat.pow_succ, Nat.mul_add, Nat.add_mul]
    omega

end Course0010

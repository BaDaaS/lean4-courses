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
  induction m with
  | zero => rfl
  | succ m ih => rw [Nat.add_succ, Nat.add_succ, ih]

-- Exercise 4
theorem add_comm (n m : Nat) : n + m = m + n := by
  induction n with
  | zero => simp
  | succ n ih => rw [Nat.succ_add, ih, Nat.add_succ]

-- Exercise 5
theorem add_assoc (n m k : Nat) : (n + m) + k = n + (m + k) := by
  induction k with
  | zero => rfl
  | succ k ih => rw [Nat.add_succ, Nat.add_succ, Nat.add_succ, ih]

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
    simp [sumTo]
    omega

-- Exercise 9
theorem length_append {alpha : Type u} (xs ys : List alpha) :
    (xs ++ ys).length = xs.length + ys.length := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp [ih]

end Course0010

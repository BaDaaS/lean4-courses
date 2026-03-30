/-
# 0010 - Natural Numbers and Induction Solutions
-/

namespace S0010

-- Exercise 1
theorem zero_add (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ n ih => rw [Nat.add_succ, ih]

-- Exercise 2
theorem add_zero (n : Nat) : n + 0 = n := by
  rfl

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

private theorem gauss_helper (n : Nat) (ih : 2 * sumTo n = n * (n + 1)) :
    2 * ((n + 1) + sumTo n) = (n + 1) * ((n + 1) + 1) := by
  have h1 : 2 * ((n + 1) + sumTo n) = 2 * (n + 1) + 2 * sumTo n :=
    Nat.left_distrib 2 (n + 1) (sumTo n)
  rw [h1, ih]
  have h2 : (n + 1) * (n + 2) = (n + 1) * n + (n + 1) * 2 :=
    Nat.left_distrib (n + 1) n 2
  have h3 : (n + 1) * n = n * (n + 1) := Nat.mul_comm (n + 1) n
  rw [h2, h3]
  omega

theorem gauss_formula (n : Nat) : 2 * sumTo n = n * (n + 1) := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [sumTo]
    exact gauss_helper n ih

-- Exercise 9
theorem length_append {alpha : Type} (xs ys : List alpha) :
    (xs ++ ys).length = xs.length + ys.length := by
  induction xs with
  | nil => simp
  | cons _ _ ih => simp [ih]; omega

end S0010

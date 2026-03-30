/-
# 0010 - Natural Numbers and Induction Exercises

Prove these properties of natural numbers by induction.
-/

-- Exercise 1: Prove that 0 + n = n
theorem zero_add (n : Nat) : 0 + n = n := by
  sorry

-- Exercise 2: Prove that n + 0 = n
theorem add_zero (n : Nat) : n + 0 = n := by
  sorry

-- Exercise 3: Prove successor distributes over addition
theorem succ_add (n m : Nat) : (n + 1) + m = (n + m) + 1 := by
  sorry

-- Exercise 4: Prove addition is commutative
-- Hint: use induction and the lemmas above
theorem add_comm (n m : Nat) : n + m = m + n := by
  sorry

-- Exercise 5: Prove addition is associative
theorem add_assoc (n m k : Nat) : (n + m) + k = n + (m + k) := by
  sorry

-- Exercise 6: Prove 0 * n = 0
theorem zero_mul (n : Nat) : 0 * n = 0 := by
  sorry

-- Exercise 7: Prove n * 0 = 0
theorem mul_zero (n : Nat) : n * 0 = 0 := by
  sorry

-- Exercise 8: Prove that sum of first n numbers = n * (n + 1) / 2
-- Hint: prove 2 * sum n = n * (n + 1) to avoid division
def sumTo : Nat -> Nat
  | 0 => 0
  | n + 1 => (n + 1) + sumTo n

theorem gauss_formula (n : Nat) : 2 * sumTo n = n * (n + 1) := by
  sorry

-- Exercise 9 (challenge): Prove that length of append = sum of lengths
theorem length_append (xs ys : List alpha) :
    (xs ++ ys).length = xs.length + ys.length := by
  sorry

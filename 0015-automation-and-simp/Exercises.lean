/-
# 0015 - Automation and Simp Exercises

Choose the right automation tactic for each exercise.
-/

-- Exercise 1: Use simp
theorem simp_ex1 (xs ys : List Nat) : (xs ++ ys).length = xs.length + ys.length := by
  sorry

-- Exercise 2: Use omega
theorem omega_ex1 (n : Nat) (h : n >= 10) : n >= 5 := by
  sorry

-- Exercise 3: Use omega
theorem omega_ex2 (a b : Nat) (h1 : a > b) (h2 : b > 0) : a >= 2 := by
  sorry

-- Exercise 4: Use decide
theorem decide_ex1 : 15 % 4 = 3 := by
  sorry

-- Exercise 5: Use simp with specific lemmas
theorem simp_ex2 (n : Nat) : n * 1 = n := by
  sorry

-- Exercise 6: Prove using the right combination of tactics
theorem combo_ex1 (xs : List Nat) : (xs ++ []).length = xs.length := by
  sorry

-- Exercise 7: Define a simp lemma and use it
def double (n : Nat) : Nat := n + n

@[simp]
theorem double_eq (n : Nat) : double n = n + n := rfl

theorem double_4 : double 4 = 8 := by
  sorry

-- Exercise 8: omega for integer arithmetic
theorem omega_int (a b : Int) (h : a + b > 10) (h2 : a <= 5) : b > 5 := by
  sorry

-- Exercise 9: Combine simp and omega
theorem combo_ex2 (xs : List Nat) (h : xs.length > 0) :
    (xs ++ [42]).length > 1 := by
  sorry

-- Exercise 10 (challenge): Prove without looking at the solution
-- Hint: think about what tactic handles what domain
theorem challenge_auto (n m : Nat) (h : n > 0) (h2 : m > 0) :
    n * m > 0 := by
  sorry

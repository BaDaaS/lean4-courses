/-
# 0004 - Tactics Exercises

All proofs should use tactic mode (start with `by`).
-/

variable (P Q R : Prop)

-- Exercise 1: Prove P -> P using tactics
theorem id_tactic : P -> P := by
  sorry

-- Exercise 2: Prove And introduction
theorem and_intro_tactic (hp : P) (hq : Q) : P /\ Q := by
  sorry

-- Exercise 3: Prove Or commutativity using cases
theorem or_comm_tactic : P \/ Q -> Q \/ P := by
  sorry

-- Exercise 4: Use rw to prove an equality
-- Hint: rewrite using h, then use rfl
theorem rw_example (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  sorry

-- Exercise 5: Use omega to solve arithmetic
theorem arith_example (n : Nat) (h : n >= 5) : n >= 3 := by
  sorry

-- Exercise 6: Prove implication transitivity with tactics
theorem trans_tactic : (P -> Q) -> (Q -> R) -> P -> R := by
  sorry

-- Exercise 7: Use simp to simplify
theorem simp_example (xs : List Nat) : xs ++ [] = xs := by
  sorry

-- Exercise 8: Prove And is associative
theorem and_assoc_tactic : (P /\ Q) /\ R -> P /\ (Q /\ R) := by
  sorry

-- Exercise 9 (challenge): Prove this using only tactics
theorem challenge : (P -> Q) -> (Q -> R) -> (R -> P) -> P -> P /\ Q /\ R := by
  sorry

/-
# 0004 - Tactics Exercises

All proofs should use tactic mode (start with `by`).
-/

variable (P Q R : Prop)

-- Exercise 1: Prove P -> P using tactics
theorem id_tactic : P -> P := by
  intro hp
  exact hp

example (hpq : P -> Q) (hp : P) : Q := by
  apply hpq
  exact hp

example (hp: P) (hq: Q) : P /\ Q := by
  refine And.intro ?_ ?_
  exact hp
  exact hq

example (hp: P) (hq: Q): P /\ Q := by
  constructor
  . exact hp
  . exact hq

example : Exists (fun n : Nat => n > 0) := by
  exists 1

example (h: P \/ Q) : Q \/ P := by
  cases h with
  | inl hp => right; exact hp
  | inr hp => left; exact hp

-- Exercise 2: Prove And introduction
theorem and_intro_tactic (hp : P) (hq : Q) : P /\ Q := by
  constructor
  . exact hp
  . exact hq

-- Exercise 3: Prove Or commutativity using cases
theorem or_comm_tactic : P \/ Q -> Q \/ P := by
  intro h
  cases h with
  | inl hp => right; exact hp
  | inr hq => left; exact hq

-- Exercise 4: Use rw to prove an equality
-- Hint: rewrite using h, then use rfl
theorem rw_example (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  rw [h]

-- Exercise 5: Use omega to solve arithmetic
theorem arith_example (n : Nat) (h : n >= 5) : n >= 3 := by
  omega

-- Exercise 6: Prove implication transitivity with tactics
theorem trans_tactic : (P -> Q) -> (Q -> R) -> P -> R := by
  intro hpq hqr hp
  apply hqr
  apply hpq
  exact hp

-- Exercise 7: Use simp to simplify
theorem simp_example (xs : List Nat) : xs ++ [] = xs := by
  sorry

-- Exercise 8: Prove And is associative
theorem and_assoc_tactic : (P /\ Q) /\ R -> P /\ (Q /\ R) := by
  sorry

-- Exercise 9 (challenge): Prove this using only tactics
theorem challenge : (P -> Q) -> (Q -> R) -> (R -> P) -> P -> P /\ Q /\ R := by
  sorry

-- =============================================
-- Additional exercises (increasing difficulty)
-- =============================================

-- Exercise 10 (medium): Use obtain to destructure nested And
-- Given P /\ (Q /\ R), prove R /\ P
theorem nested_and : P /\ (Q /\ R) -> R /\ P := by
  sorry

-- Exercise 11 (hard): Prove an iff using constructor
-- P /\ Q <-> Q /\ P
theorem and_comm_iff : P /\ Q <-> Q /\ P := by
  sorry

-- Exercise 12 (hard): Use a calc block for multi-step equality
-- Prove that (a + b) + c = (c + b) + a for natural numbers
-- Hint: use Nat.add_comm and Nat.add_assoc in calc steps
theorem add_rearrange (a b c : Nat) :
    (a + b) + c = (c + b) + a := by
  sorry

-- Exercise 13 (challenge): Prove that reversing a non-empty list
-- preserves the property of having length > 0.
-- Hint: use simp with List.length_reverse
theorem reverse_length_pos (alpha : Type) (xs : List alpha)
    (h : xs.length > 0) : xs.reverse.length > 0 := by
  sorry

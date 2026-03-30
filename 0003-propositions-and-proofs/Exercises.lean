/-
# 0003 - Propositions and Proofs Exercises
-/

variable (P Q R : Prop)

-- Exercise 1: Prove that P implies P (identity)
theorem self_impl : P -> P := fun hp => hp

-- Exercise 2: Prove transitivity of implication
theorem impl_trans : (P -> Q) -> (Q -> R) -> (P -> R) :=
  fun hpq hqr hp => hqr (hpq hp)


-- Exercise 3: Prove And is commutative
theorem and_comm_proof : P /\ Q -> Q /\ P :=
  fun hpq => And.intro hpq.right hpq.left

-- Exercise 4: Prove Or is commutative
theorem or_comm_proof : P \/ Q -> Q \/ P :=
  fun hpq => match hpq with
  | Or.inl hp => Or.inr hp
  | Or.inr hq => Or.inl hq

-- Exercise 5: Prove that False implies anything
theorem false_elim : False -> P := fun h => False.elim h

-- Exercise 6: Prove modus tollens: if P -> Q and not Q, then not P
-- Recall: Not P is defined as P -> False
theorem modus_tollens : (P -> Q) -> Not Q -> Not P :=
  -- we can see hnq as a function from Q to False.
  -- so we have
  -- hpq : P to Q
  -- hnq : Q to False
  -- hp : P
  fun hpq hnq hp => hnq (hpq hp)

-- Exercise 7: Prove And distributes over Or
--                              h
--                       ------------
--                    h.left
--                            Or.inl
theorem and_or_distrib : P /\ (Q \/ R) -> (P /\ Q) \/ (P /\ R) :=
  fun h =>
    match h.right with
    | Or.inl q => Or.inl (And.intro h.left q)
    | Or.inr r => Or.inr (And.intro h.left r)

-- Exercise 8: Construct an existential proof
-- Prove there exists a natural number equal to 2 + 3
theorem exists_five : Exists (fun n : Nat => n = 2 + 3) :=
  Exists.intro 5 rfl

-- Exercise 9 (challenge): Prove one direction of De Morgan's law
theorem de_morgan_and : Not (P \/ Q) -> Not P /\ Not Q :=
  fun h =>
    And.intro (fun hp => h (Or.inl hp)) (fun hq => h (Or.inr hq))

-- =============================================
-- Additional exercises (increasing difficulty)
-- =============================================

-- Exercise 10 (medium): Prove left projection from And
-- If P /\ Q holds, then P holds.
theorem and_left : P /\ Q -> P := sorry

-- Exercise 11 (hard): Prove the contrapositive
-- If P implies Q, then Not Q implies Not P.
-- Recall: Not X is defined as X -> False
theorem contrapositive : (P -> Q) -> (Not Q -> Not P) := sorry

-- Exercise 12 (hard): Peirce's law requires classical logic.
-- We cannot prove ((P -> Q) -> P) -> P constructively.
-- Instead, prove a weaker version: show that with classical
-- excluded middle, we can derive it.
-- Hint: use Classical.em P to case-split on P \/ Not P
theorem peirce_classical : ((P -> Q) -> P) -> P := by
  sorry

-- Exercise 13 (challenge): Prove one direction of material implication.
-- (P -> Q) -> (Not P \/ Q)
-- This requires classical logic. Use Classical.em P.
theorem material_implication : (P -> Q) -> (Not P \/ Q) := by
  sorry

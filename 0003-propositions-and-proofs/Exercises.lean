/-
# 0003 - Propositions and Proofs Exercises
-/

variable (P Q R : Prop)

-- Exercise 1: Prove that P implies P (identity)
theorem self_impl : P -> P := sorry

-- Exercise 2: Prove transitivity of implication
theorem impl_trans : (P -> Q) -> (Q -> R) -> (P -> R) := sorry

-- Exercise 3: Prove And is commutative
theorem and_comm_proof : P /\ Q -> Q /\ P := sorry

-- Exercise 4: Prove Or is commutative
theorem or_comm_proof : P \/ Q -> Q \/ P := sorry

-- Exercise 5: Prove that False implies anything
theorem false_elim : False -> P := sorry

-- Exercise 6: Prove modus tollens: if P -> Q and not Q, then not P
-- Recall: Not P is defined as P -> False
theorem modus_tollens : (P -> Q) -> Not Q -> Not P := sorry

-- Exercise 7: Prove And distributes over Or
theorem and_or_distrib : P /\ (Q \/ R) -> (P /\ Q) \/ (P /\ R) := sorry

-- Exercise 8: Construct an existential proof
-- Prove there exists a natural number equal to 2 + 3
theorem exists_five : Exists (fun n : Nat => n = 2 + 3) := sorry

-- Exercise 9 (challenge): Prove one direction of De Morgan's law
theorem de_morgan_and : Not (P \/ Q) -> Not P /\ Not Q := sorry

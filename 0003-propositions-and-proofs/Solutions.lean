/-
# 0003 - Propositions and Proofs Solutions
-/

namespace Course0003

-- Exercise 1
theorem self_impl (P : Prop) : P -> P :=
  fun hp => hp

-- Exercise 2
theorem impl_trans (P Q R : Prop) : (P -> Q) -> (Q -> R) -> (P -> R) :=
  fun hpq hqr hp => hqr (hpq hp)

-- Exercise 3
theorem and_comm_proof (P Q : Prop) : P /\ Q -> Q /\ P :=
  fun h => And.intro h.right h.left

-- Exercise 4
theorem or_comm_proof (P Q : Prop) : P \/ Q -> Q \/ P :=
  fun h =>
    match h with
    | Or.inl hp => Or.inr hp
    | Or.inr hq => Or.inl hq

-- Exercise 5
theorem false_elim (P : Prop) : False -> P :=
  fun h => False.elim h

-- Exercise 6
theorem modus_tollens (P Q : Prop) : (P -> Q) -> Not Q -> Not P :=
  fun hpq hnq hp => hnq (hpq hp)

-- Exercise 7
theorem and_or_distrib (P Q R : Prop) :
    P /\ (Q \/ R) -> (P /\ Q) \/ (P /\ R) :=
  fun h =>
    match h.right with
    | Or.inl hq => Or.inl (And.intro h.left hq)
    | Or.inr hr => Or.inr (And.intro h.left hr)

-- Exercise 8
theorem exists_five : Exists (fun n : Nat => n = 2 + 3) :=
  Exists.intro 5 rfl

-- Exercise 9
theorem de_morgan_and (P Q : Prop) :
    Not (P \/ Q) -> Not P /\ Not Q :=
  fun h => And.intro
    (fun hp => h (Or.inl hp))
    (fun hq => h (Or.inr hq))

-- =============================================
-- Additional exercises (increasing difficulty)
-- =============================================

-- Exercise 10 (medium): Left projection from And
theorem and_left (P Q : Prop) : P /\ Q -> P :=
  fun h => h.left

-- Exercise 11 (hard): Contrapositive
theorem contrapositive (P Q : Prop) : (P -> Q) -> (Not Q -> Not P) :=
  fun hpq hnq hp => hnq (hpq hp)

-- Exercise 12 (hard): Peirce's law using classical logic
theorem peirce_classical (P Q : Prop) : ((P -> Q) -> P) -> P := by
  intro h
  cases Classical.em P with
  | inl hp  => exact hp
  | inr hnp =>
    apply h
    intro hp
    exact absurd hp hnp

-- Exercise 13 (challenge): Material implication
theorem material_implication (P Q : Prop) : (P -> Q) -> (Not P \/ Q) := by
  intro hpq
  cases Classical.em P with
  | inl hp  => exact Or.inr (hpq hp)
  | inr hnp => exact Or.inl hnp

end Course0003

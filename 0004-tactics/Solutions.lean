/-
# 0004 - Tactics Solutions
-/

namespace Course0004

-- Exercise 1
theorem id_tactic (P : Prop) : P -> P := by
  intro hp
  exact hp

-- Exercise 2
theorem and_intro_tactic (P Q : Prop) (hp : P) (hq : Q) : P /\ Q := by
  constructor
  . exact hp
  . exact hq

-- Exercise 3
theorem or_comm_tactic (P Q : Prop) : P \/ Q -> Q \/ P := by
  intro h
  cases h with
  | inl hp => right; exact hp
  | inr hq => left; exact hq

-- Exercise 4
theorem rw_example (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  rw [h]

-- Exercise 5
theorem arith_example (n : Nat) (h : n >= 5) : n >= 3 := by
  omega

-- Exercise 6
theorem trans_tactic (P Q R : Prop) :
    (P -> Q) -> (Q -> R) -> P -> R := by
  intro hpq hqr hp
  apply hqr
  apply hpq
  exact hp

-- Exercise 7
theorem simp_example (xs : List Nat) : xs ++ [] = xs := by
  simp

-- Exercise 8
theorem and_assoc_tactic (P Q R : Prop) :
    (P /\ Q) /\ R -> P /\ (Q /\ R) := by
  intro h
  obtain <<hp, hq>, hr> := h
  exact <hp, hq, hr>

-- Exercise 9
theorem challenge (P Q R : Prop) :
    (P -> Q) -> (Q -> R) -> (R -> P) -> P -> P /\ Q /\ R := by
  intro hpq hqr _hrp hp
  constructor
  . exact hp
  constructor
  . exact hpq hp
  . exact hqr (hpq hp)

end Course0004

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
  obtain ⟨⟨hp, hq⟩, hr⟩ := h
  exact ⟨hp, hq, hr⟩

-- Exercise 9
theorem challenge (P Q R : Prop) :
    (P -> Q) -> (Q -> R) -> (R -> P) -> P -> P /\ Q /\ R := by
  intro hpq hqr _hrp hp
  constructor
  . exact hp
  constructor
  . exact hpq hp
  . exact hqr (hpq hp)

-- =============================================
-- Additional exercises (increasing difficulty)
-- =============================================

-- Exercise 10 (medium): Destructure nested And with obtain
theorem nested_and (P Q R : Prop) : P /\ (Q /\ R) -> R /\ P := by
  intro h
  obtain ⟨hp, _hq, hr⟩ := h
  exact ⟨hr, hp⟩

-- Exercise 11 (hard): Prove iff using constructor
theorem and_comm_iff (P Q : Prop) : P /\ Q <-> Q /\ P := by
  constructor
  . intro h
    exact ⟨h.right, h.left⟩
  . intro h
    exact ⟨h.right, h.left⟩

-- Exercise 12 (hard): calc block for multi-step equality
theorem add_rearrange (a b c : Nat) :
    (a + b) + c = (c + b) + a := by
  omega

-- Exercise 13 (challenge): Reverse preserves positive length
theorem reverse_length_pos (alpha : Type) (xs : List alpha)
    (h : xs.length > 0) : xs.reverse.length > 0 := by
  simp [List.length_reverse]
  exact h

end Course0004

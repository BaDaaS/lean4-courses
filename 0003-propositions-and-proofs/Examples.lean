/-
# 0003 - Propositions and Proofs Examples

Runnable examples from the README, anchored for documentation.
-/

namespace Course0003Examples

variable (P Q R : Prop)

-- #anchor: modus_ponens
theorem my_modus_ponens (hpq : P -> Q) (hp : P) : Q :=
  hpq hp
-- #end

-- #anchor: and_intro
-- Constructing And (/\I rule)
theorem my_and_intro (hp : P) (hq : Q) : P /\ Q :=
  And.intro hp hq

-- Destructing And (/\E rules)
theorem my_and_left (h : P /\ Q) : P :=
  h.left    -- or And.left h or h.1
-- #end

-- #anchor: and_structure
-- Under the hood, And is an inductive type (a structure):
-- structure And (a b : Prop) : Prop where
--   intro ::
--   left : a
--   right : b
-- So P /\ Q is a product type (a pair of proofs).
-- #end

-- #anchor: or_intro_elim
-- Constructing Or (\/I rule)
theorem my_or_left (hp : P) : P \/ Q :=
  Or.inl hp

-- Destructing Or (\/E rule, case analysis)
theorem my_or_comm (h : P \/ Q) : Q \/ P :=
  match h with
  | Or.inl hp => Or.inr hp
  | Or.inr hq => Or.inl hq
-- #end

-- #anchor: or_inductive
-- Under the hood, Or is an inductive type with two constructors:
-- inductive Or (a b : Prop) : Prop where
--   | inl (h : a) : Or a b
--   | inr (h : b) : Or a b
-- So P \/ Q is a sum type (a tagged union).
-- #end

-- #anchor: negation
theorem my_not_false_proof : Not False :=
  fun h => h    -- False implies anything

theorem my_absurd_example (hp : P) (hnp : Not P) : Q :=
  absurd hp hnp
-- #end

-- #anchor: exists_example
theorem my_exists_example : Exists (fun n : Nat => n > 0) :=
  Exists.intro 1 (Nat.lt_add_one 0)
  -- witness: 1, proof: 0 < 1
-- #end

-- #anchor: exists_inductive
-- Under the hood, Exists is a dependent pair (Sigma type in Prop):
-- inductive Exists {alpha : Sort u}
--     (p : alpha -> Prop) : Prop where
--   | intro (w : alpha) (h : p w) : Exists p
-- A proof of exists x, P x consists of a witness and a proof.
-- #end

-- #anchor: forall_example
theorem my_all_nat_pos :
    forall n : Nat, 0 <= n :=
  fun n => Nat.zero_le n
-- #end

-- #anchor: theorem_vs_def
def my_proof : 1 + 1 = 2 := rfl
-- #end

end Course0003Examples

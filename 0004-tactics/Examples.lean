/-
# 0004 - Tactics Examples

Runnable examples from the course README, organized with anchor markers
so the README can reference them directly.
-/

namespace Course0004Examples

variable (P Q R : Prop)

-- #anchor: forward_reasoning
-- Start from hp and hpq, derive the goal
theorem ex1 (hp : P) (hpq : P -> Q) : Q :=
  hpq hp    -- apply what we know to get Q
-- #end

-- #anchor: backward_reasoning
-- Start from the goal Q, reduce it
theorem ex2 (hp : P) (hpq : P -> Q) : Q := by
  apply hpq    -- Q reduces to subgoal P
  exact hp     -- P is in the context
-- #end

-- #anchor: term_vs_tactic_mode
-- Term mode: construct the proof directly
theorem p_implies_p_term (P' : Prop) : P' -> P' :=
  fun hp => hp

-- Tactic mode: use `by` to enter tactic mode
theorem p_implies_p_tactic (P' : Prop) : P' -> P' := by
  intro hp
  exact hp
-- #end

-- #anchor: curry_howard_side_by_side
-- Term mode: you write the whole function at once
theorem ex_term (P' Q' : Prop) : P' -> Q' -> P' :=
  fun hp _hq => hp

-- Tactic mode: you build the same function step by step
theorem ex_tactic (P' Q' : Prop) : P' -> Q' -> P' := by
  -- Goal: P' -> Q' -> P' (a function type)
  intro hp
  -- "fun hp =>" ... now Goal: Q' -> P'
  intro _hq
  -- "fun _hq =>" ... now Goal: P'
  exact hp
  -- return hp. Done. The built term is: fun hp _hq => hp
-- #end

-- #anchor: intro_tactic
example (P' Q' : Prop) : P' -> Q' -> P' := by
  intro hp _hq   -- fun hp _hq =>
  exact hp        -- hp
-- #end

-- #anchor: exact_tactic
example (hp : P) : P := by
  exact hp
-- #end

-- #anchor: apply_tactic
example (hpq : P -> Q) (hp : P) : Q := by
  apply hpq    -- hpq ?_
  exact hp     -- hpq hp
-- #end

-- #anchor: refine_tactic
example (hp : P) (hq : Q) : P /\ Q := by
  refine And.intro ?_ ?_   -- And.intro ?_ ?_
  exact hp                  -- And.intro hp ?_
  exact hq                  -- And.intro hp hq
-- #end

-- #anchor: constructor_tactic
example (hp : P) (hq : Q) : P /\ Q := by
  constructor      -- And.intro ?_ ?_
  . exact hp       -- And.intro hp ?_
  . exact hq       -- And.intro hp hq
-- #end

-- #anchor: left_right_tactic
example (hp : P) : P \/ Q := by
  left         -- Or.inl ?_
  exact hp     -- Or.inl hp
-- #end

-- #anchor: exists_tactic
example : Exists (fun n : Nat => n > 0) := by
  exists 1     -- Exists.intro 1 ?_ ... then omega closes the proof
-- #end

-- #anchor: cases_tactic
example (h : P \/ Q) : Q \/ P := by
  cases h with
  | inl hp => right; exact hp    -- Or.inr hp
  | inr hq => left; exact hq    -- Or.inl hq
-- #end

-- #anchor: obtain_tactic
example (h : P /\ (Q /\ R)) : R := by
  obtain ⟨_, _, hr⟩ := h    -- let ⟨_, _, hr⟩ := h
  exact hr
-- #end

-- #anchor: induction_tactic
theorem zero_add (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ n ih => rw [Nat.add_succ, ih]
-- #end

-- #anchor: rfl_tactic
example : 2 + 2 = 4 := by rfl
-- #end

section RwExample

variable (a b c : Nat)

-- #anchor: rw_tactic
example (h : a = b) : a + c = b + c := by
  rw [h]    -- goal becomes b + c = b + c, closed by rfl
-- #end

end RwExample

-- #anchor: have_tactic
example (hp : P) (hpq : P -> Q) : Q := by
  have hq : Q := hpq hp    -- let hq := hpq hp
  exact hq
-- #end

-- #anchor: exfalso_tactic
example (hp : P) (hnp : Not P) : Q := by
  exfalso           -- goal becomes False
  exact hnp hp      -- hnp hp : False
-- #end

-- #anchor: contradiction_tactic
example (hp : P) (hnp : Not P) : Q := by
  contradiction
-- #end

-- #anchor: ext_tactic
example (f g : Nat -> Nat) (h : forall x, f x = g x) :
    f = g := by
  ext x         -- fun x => ...
  exact h x
-- #end

section CalcExample

variable (a b c : Nat)

-- #anchor: symm_calc_tactic
example (h1 : a = b) (h2 : b = c) : a = c := by
  calc a = b := h1
    _ = c := h2
-- #end

end CalcExample

-- #anchor: decide_tactic
example : 2 + 2 = 4 := by decide
-- #end

-- #anchor: tactic_combinators
-- Try the first tactic that succeeds
example : 1 + 1 = 2 := by first | rfl | simp | omega

-- Apply next tactic to ALL subgoals
example (hp : P) (hq : Q) : P /\ Q := by
  constructor <;> assumption

-- Try, but don't fail if it doesn't work; simp closes True here
example : True := by
  try simp

-- Repeat a tactic until it fails
example : True /\ True /\ True := by
  repeat' constructor <;> trivial
-- #end

end Course0004Examples

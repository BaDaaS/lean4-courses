# 0004 - Tactics

## Goal

Learn tactic-mode proofs. Instead of constructing proof terms directly,
you use commands (tactics) that transform the proof state step by step.

## Term Mode vs Tactic Mode

```lean
-- Term mode: construct the proof directly
theorem p_implies_p_term (P : Prop) : P -> P :=
  fun hp => hp

-- Tactic mode: use `by` to enter tactic mode
theorem p_implies_p_tactic (P : Prop) : P -> P := by
  intro hp
  exact hp
```

## Essential Tactics

### intro / intros

Move hypotheses from the goal into the context:

```lean
example (P Q : Prop) : P -> Q -> P := by
  intro hp _hq
  exact hp
```

### exact

Provide an exact proof term:

```lean
example (hp : P) : P := by
  exact hp
```

### apply

Apply a function/theorem whose conclusion matches the goal:

```lean
example (hpq : P -> Q) (hp : P) : Q := by
  apply hpq
  exact hp
```

### constructor

Split a goal into subgoals (for And, Iff, etc.):

```lean
example (hp : P) (hq : Q) : P /\ Q := by
  constructor
  . exact hp
  . exact hq
```

### cases / rcases

Case-split on a hypothesis:

```lean
example (h : P \/ Q) : Q \/ P := by
  cases h with
  | inl hp => right; exact hp
  | inr hq => left; exact hq
```

### simp

The simplifier applies known lemmas automatically:

```lean
example (n : Nat) : n + 0 = n := by
  simp
```

### rfl

Close a goal that is true by reflexivity:

```lean
example : 2 + 3 = 5 := by
  rfl
```

### rw (rewrite)

Replace a subexpression using an equality:

```lean
example (h : a = b) : a + c = b + c := by
  rw [h]
```

### omega

Solve linear arithmetic over Nat and Int:

```lean
example (n : Nat) : n + 1 > n := by
  omega
```

## Tactic Combinators

```lean
-- Semicolon applies next tactic to all goals
example (P Q : Prop) (hp : P) (hq : Q) : P /\ Q := by
  constructor <;> assumption

-- <;> means "apply the next tactic to all remaining goals"
```

## Math Track

Tactic proofs mirror how mathematicians think: "assume P, then by
hypothesis we have Q, therefore...". The tactic state shows you
exactly what you know (hypotheses) and what you need to show (goal).

## CS Track

Tactics are a domain-specific language for proof search. Think of
the proof state as a program synthesis problem: you have a type (goal)
and available terms (hypotheses), and tactics help you compose them.

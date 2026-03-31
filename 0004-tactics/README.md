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

Both modes produce the same thing: a term of the right type.
Tactic mode is just a different way to build that term, step by step.

## The Curry-Howard View of Tactics

Recall from course 0003: propositions are types, proofs are terms.
A goal `P -> Q` is a function type. You need to construct a function.

Tactic mode is a **term construction machine**. At each step, you have:
- A **goal**: the type of the term you still need to build
- A **context**: the terms (hypotheses) you already have

Each tactic transforms the goal by partially building the term:

| Tactic | What it does (type theory) |
|--------|--------------------------|
| `intro hp` | You need to build a term of type `P -> Q`. This is a function type. `intro hp` says: "assume we have a term `hp : P`" (i.e., take a function argument). The goal becomes `Q`. This is exactly `fun hp =>` in term mode. |
| `exact hp` | You have a term `hp` whose type matches the goal exactly. Hand it back. This is the `return` of the construction: "here is the term you wanted." |
| `apply f` | You have `f : A -> B` and the goal is `B`. `apply f` says: "I will use `f` to build a `B`, but I still need an `A`." The goal becomes `A`. |
| `constructor` | The goal is a product type (e.g., `P /\ Q`). Build it by providing both components. Two new goals appear: `P` and `Q`. |
| `cases h` | You have `h : P \/ Q` (a sum type). Pattern-match on it: one branch for `P`, one for `Q`. |

In other words:
- `intro` = take a function argument (like `fun x =>`)
- `exact` = return the final term (like the body of the function)
- `apply` = use a function, leaving its arguments as subgoals
- `constructor` = build a pair/struct
- `cases` = pattern-match on a sum type

**Example, side by side:**

```lean
-- Term mode: you write the whole function at once
theorem ex_term (P Q : Prop) : P -> Q -> P :=
  fun hp _hq => hp

-- Tactic mode: you build the same function step by step
theorem ex_tactic (P Q : Prop) : P -> Q -> P := by
  -- Goal: P -> Q -> P (a function type)
  intro hp
  -- "fun hp =>" ... now Goal: Q -> P
  intro _hq
  -- "fun _hq =>" ... now Goal: P
  exact hp
  -- return hp. Done. The built term is: fun hp _hq => hp
```

The tactic proof produces exactly the same term as the term-mode
proof. You can verify this with `#print ex_tactic`.

## Essential Tactics

### intro / intros

When the goal is a function type `A -> B`, `intro h` assumes you
have a term `h : A` and changes the goal to `B`. This is the
equivalent of writing `fun h =>` in term mode.

```lean
example (P Q : Prop) : P -> Q -> P := by
  intro hp _hq
  exact hp
```

### exact

Provide a term whose type matches the goal exactly. This closes the
goal. Think of it as the "return statement" of the tactic proof.

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

When a mathematician says "assume P holds", they are doing exactly
what `intro hp` does: taking an arbitrary proof of P and working
with it. When they say "by hypothesis, we are done", that is `exact`.

## CS Track

Tactics are a term-construction DSL. The tactic state is a
partially-built program:

- The **goal** is the return type you still need to produce
- The **context** is the set of variables in scope
- Each tactic is a step in building the program

`intro` = accept a function argument.
`exact` = return a value.
`apply f` = call function `f`, leaving its arguments as TODOs.
`constructor` = build a struct/tuple.
`cases` = pattern-match.

When all goals are closed, Lean has a complete term. The tactic
block compiles down to exactly the same lambda term you would have
written by hand. Tactics are just an interactive way to write it.

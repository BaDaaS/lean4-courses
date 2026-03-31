# Exhaustive Lean 4 Tactics Reference

Every tactic explained through the Curry-Howard lens: what term is
actually being constructed under the hood.

Recall: propositions are types, proofs are terms. A goal is a type
you need to inhabit. The context is the set of terms you have. Every
tactic is a step in building a lambda term.

---

## 1. Introducing and Returning Terms

### intro / intros

**What you write:**

```lean
example (P Q : Prop) : P -> Q -> P := by
  intro hp hq
  exact hp
```

**What it builds:** `fun hp hq => hp`

The goal `P -> Q -> P` is a function type. `intro hp` peels off the
first arrow and binds its argument as `hp : P` in the context. The
goal becomes `Q -> P`. Then `intro hq` peels off the next arrow.

`intros` introduces all leading universals/implications at once.

`intro h1 h2 h3` is exactly `fun h1 h2 h3 =>`.

### introMatch

**What you write:**

```lean
example : Bool -> Nat := by
  intro
  | true => exact 1
  | false => exact 0
```

**What it builds:** `fun b => match b with | true => 1 | false => 0`

Combines `intro` with immediate pattern matching on the introduced
variable.

### exact

**What you write:**

```lean
example (hp : P) : P := by
  exact hp
```

**What it builds:** `hp`

Provides the final term. Closes the goal. This is the "return" of
term construction. The term must have exactly the type of the goal.

### refine

**What you write:**

```lean
example (hp : P) (hq : Q) : P /\ Q := by
  refine And.intro ?_ ?_
  exact hp
  exact hq
```

**What it builds:** `And.intro hp hq`

Like `exact`, but allows holes (`?_`). Each hole becomes a new
subgoal. You provide a partial term and fill in the blanks later.

`refine'` is the same but automatically creates holes for any
implicit arguments it cannot infer.

### apply

**What you write:**

```lean
example (hpq : P -> Q) (hp : P) : Q := by
  apply hpq
  exact hp
```

**What it builds:** `hpq hp`

The goal is `Q`. You have `hpq : P -> Q`. `apply hpq` says: "I will
use this function to produce a `Q`, but I still need a `P`." The goal
becomes `P` (the argument type).

`apply` is `refine f ?_ ?_ ...` where the holes are the arguments.

### assumption

**What you write:**

```lean
example (hp : P) : P := by
  assumption
```

**What it builds:** `hp`

Searches the context for any term whose type matches the goal. It is
`exact` where Lean picks the term for you.

---

## 2. Building Composite Types

### constructor

**What you write:**

```lean
example (hp : P) (hq : Q) : P /\ Q := by
  constructor
  . exact hp
  . exact hq
```

**What it builds:** `And.intro hp hq`

The goal is a structure/inductive with one constructor. `constructor`
applies that constructor, creating one subgoal per argument.

For `P /\ Q`, the constructor is `And.intro : P -> Q -> P /\ Q`, so
two subgoals appear: `P` and `Q`.

### left / right

**What you write:**

```lean
example (hp : P) : P \/ Q := by
  left
  exact hp
```

**What it builds:** `Or.inl hp`

The goal is a sum type with two constructors. `left` picks the first
constructor (`Or.inl`), `right` picks the second (`Or.inr`).

### exists

**What you write:**

```lean
example : Exists (fun n : Nat => n > 0) := by
  exists 1
```

**What it builds:** `Exists.intro 1 (by omega)` (or similar)

Provides the witness for an existential. The goal `Exists P` needs a
term `a` and a proof of `P a`. `exists a` supplies `a`, and the goal
becomes `P a`.

This is `refine Exists.intro 1 ?_`.

---

## 3. Destructuring Terms (Pattern Matching)

### cases

**What you write:**

```lean
example (h : P \/ Q) : Q \/ P := by
  cases h with
  | inl hp => right; exact hp
  | inr hq => left; exact hq
```

**What it builds:**

```lean
match h with
| Or.inl hp => Or.inr hp
| Or.inr hq => Or.inl hq
```

You have a term `h` of a sum/inductive type. `cases h` pattern-matches
on it. Each constructor becomes a branch. In each branch, the
constructor's arguments are bound in the context.

### rcases / rintro

**What you write:**

```lean
example (h : P /\ (Q \/ R)) : (P /\ Q) \/ (P /\ R) := by
  rcases h with ⟨hp, hq | hr⟩
  . left; exact ⟨hp, hq⟩
  . right; exact ⟨hp, hr⟩
```

**What it builds:** nested pattern matching.

Recursive `cases`. Destructures nested structures in one step.
`rintro` combines `intro` with `rcases`.

### obtain

**What you write:**

```lean
example (h : Exists (fun n : Nat => n > 0)) : True := by
  obtain ⟨n, hn⟩ := h
  trivial
```

**What it builds:** `let ⟨n, hn⟩ := h; trivial`

Destructures a term and binds the pieces. `obtain ⟨a, b⟩ := h` is
`rcases h with ⟨a, b⟩`.

### match (in tactic mode)

**What you write:**

```lean
example (b : Bool) : Nat := by
  match b with
  | true => exact 1
  | false => exact 0
```

**What it builds:** `match b with | true => 1 | false => 0`

Full pattern matching inside tactic mode.

### injection

**What you write:**

```lean
example (h : Nat.succ n = Nat.succ m) : n = m := by
  injection h
```

**What it builds:** Uses the fact that constructors are injective.
`Nat.succ n = Nat.succ m` implies `n = m`.

Under the hood, this applies `Nat.succ.inj` or similar.

### split

**What you write:**

```lean
example (n : Nat) : (if n = 0 then 1 else n) > 0 := by
  split
  . omega
  . omega
```

**What it builds:** Case split on a match/if expression in the goal.
Each branch of the if/match becomes a separate goal.

---

## 4. Induction

### induction

**What you write:**

```lean
theorem add_zero (n : Nat) : n + 0 = n := by
  induction n with
  | zero => rfl
  | succ n ih => simp [Nat.succ_add, ih]
```

**What it builds:** `Nat.rec (motive := ...) rfl (fun n ih => ...) n`

Applies the recursor/eliminator of the inductive type. For `Nat`, this
is `Nat.rec` which requires a base case (for `zero`) and a step (for
`succ n`, given the induction hypothesis `ih`).

This is the computational content of mathematical induction.

### funInduction

Like `induction`, but follows the recursion pattern of a specific
function definition rather than the inductive type's recursor.

---

## 5. Equality and Rewriting

### rfl

**What you write:**

```lean
example : 2 + 2 = 4 := by rfl
```

**What it builds:** `Eq.refl 4`

Both sides of `=` reduce to the same term by computation (definitional
equality). `rfl` constructs the reflexivity proof `Eq.refl`.

This only works when both sides are *definitionally* equal (the kernel
can compute them to the same normal form).

### rw / rewrite

**What you write:**

```lean
example (h : a = b) : a + c = b + c := by
  rw [h]
```

**What it builds:** `h ▸ (Eq.refl (b + c))`

`rw [h]` finds every occurrence of `a` in the goal and replaces it
with `b` (using the equation `h : a = b`). Under the hood, it uses
`Eq.mpr` or substitution to transport the proof.

`rw [<- h]` rewrites right-to-left (replaces `b` with `a`).

`rw [h1, h2, h3]` rewrites sequentially.

### rwa

**What you write:**

```lean
example (h1 : a = b) (h2 : b = c) : a = c := by
  rwa [h1]
```

**What it builds:** Rewrite, then close with `assumption`.

`rwa [h]` = `rw [h]; assumption`. After rewriting, if the goal matches
a hypothesis, it is closed automatically.

### subst

**What you write:**

```lean
example (h : a = b) (hb : P b) : P a := by
  subst h
  exact hb
```

**What it builds:** Substitutes the equality everywhere and eliminates
the variable. After `subst h`, `a` is replaced by `b` in the entire
context and goal. The hypothesis `h` disappears.

Only works when one side of the equality is a free variable.

### symm

**What you write:**

```lean
example (h : a = b) : b = a := by
  symm
  exact h
```

**What it builds:** `Eq.symm h` (or `h.symm`)

Flips the sides of an equality (or any symmetric relation).

### calc

**What you write:**

```lean
example (a b c : Nat) : a + b + c = c + b + a := by
  calc a + b + c
    _ = c + (a + b) := by omega
    _ = c + b + a := by omega
```

**What it builds:** Chains of transitivity. Each step produces an
equality, and `Eq.trans` links them together.

`calc` is the formal version of "we have X = Y = Z, therefore X = Z."

---

## 6. Simplification and Automation

### simp

**What you write:**

```lean
example (xs : List Nat) : xs ++ [] = xs := by simp
```

**What it builds:** A chain of rewrites using lemmas tagged `@[simp]`.

`simp` is a term rewriting engine. It repeatedly applies `@[simp]`
lemmas (left-to-right) until no more apply. The result is a proof
built from a sequence of `Eq.trans`, `Eq.mpr`, congruence lemmas, etc.

Variants:
- `simp only [h1, h2]` - use only the listed lemmas
- `simp [h]` - add `h` to the simp set
- `simp at h` - simplify hypothesis `h` instead of the goal
- `simp_all` - simplify goal and all hypotheses
- `simp?` - suggest which simp lemmas were used

### dsimp

**What you write:**

```lean
example : (fun x : Nat => x) 5 = 5 := by dsimp; rfl
```

**What it builds:** Only applies definitional simplifications (beta
reduction, let unfolding, structure projections). No lemmas. The goal
changes but the proof term uses only `Eq.refl` on the simplified form.

### simpa

`simpa [h] using e` = simplify both the goal and `e`, then check they
match. Combines `simp` with `exact`.

### omega

**What you write:**

```lean
example (n : Nat) (h : n >= 5) : n >= 3 := by omega
```

**What it builds:** A proof by a decision procedure for linear
arithmetic over `Nat` and `Int`.

**The full pipeline, step by step:**

1. **Negate the goal (proof by contradiction).** omega does not build
   a direct proof. It assumes the negation of the goal and tries to
   derive `False`. For example, if the goal is `n >= 3`, omega
   assumes `n < 3` (i.e., `n <= 2`) and tries to derive a
   contradiction with the hypothesis `n >= 5`.

2. **Convert everything to linear constraints over Int.** All `Nat`
   values are cast to `Int`, and the constraint `0 <= (n : Int)` is
   automatically added (since Nat is non-negative). Comparisons are
   normalized: `x > y` becomes `x >= y + 1`, etc. The result is a
   system of linear inequalities of the form:
   ```
   c0 + c1*x1 + c2*x2 + ... + cn*xn >= 0
   ```

   For our example, the system is:
   ```
   n - 5 >= 0      (from h : n >= 5)
   2 - n >= 0      (from negated goal : n <= 2)
   n >= 0          (from Nat non-negativity)
   ```

3. **Solve equalities by substitution.** If there are any exact
   equalities (like `a = b`), omega eliminates variables by
   substitution. For "hard" equalities where no coefficient is +/-1,
   it uses a **balanced modular reduction** trick to create an easy
   equality first (this is the core insight of William Pugh's
   Omega test, 1991).

4. **Eliminate inequalities via Fourier-Motzkin.** For the remaining
   inequalities, omega picks a variable and combines all its lower
   bounds with all its upper bounds to eliminate it. For our example:
   ```
   n >= 5     (lower bound on n)
   n <= 2     (upper bound on n)
   Combine: 5 <= n <= 2, which gives 5 <= 2, contradiction!
   ```
   More precisely, subtracting: `(n - 5) + (2 - n) >= 0` gives
   `-3 >= 0`, which is `False`.

5. **Build the proof term by unwinding.** omega tracks every step
   (which hypotheses were used, which combinations were made) in a
   "justification tree." Once `False` is derived, it walks the tree
   backward and emits a chain of Lean lemma applications:
   ```
   False
     <- Constraint.not_sat'_of_isImpossible (...)
     <- combo_sat' [proof from h] [proof from negated goal]
     <- tidy_sat [normalization proof]
     <- assumption [original hypothesis]
   ```

**What omega handles:**
- `+`, `-`, `*` (by a literal constant), `/` (by literal), `%` (by literal)
- `<`, `<=`, `=`, `>=`, `>`, `!=`
- `Nat` and `Int` (including `Nat` subtraction, which is tricky since
  `(a - b : Nat)` is 0 when `a < b`)
- `Nat` division and modulo (introduces auxiliary variables with bounds)
- Divisibility (`k | n`)

**What omega does NOT handle:**
- Multiplication of two variables (`n * m` where neither is a literal)
- Nonlinear arithmetic
- Quantifiers (it only works on the current hypotheses)

**Nat subtraction, the tricky case:** When omega sees
`((a - b : Nat) : Int)`, it records a disjunction:
- Either `b <= a` and the subtraction equals `a - b` (the normal case)
- Or `a < b` and the subtraction equals `0` (Nat underflow)

It tries to find a contradiction without splitting this disjunction.
If it cannot, it splits and tries both branches.

**Algorithm:** The Omega test by William Pugh (1991), with
Fourier-Motzkin elimination for inequalities. The implementation does
not use the "dark shadow" and "grey shadow" extensions from Pugh's
full algorithm, so it is technically incomplete for problems requiring
those. In practice, this almost never matters.

**Reference:** William Pugh, "The Omega Test: a fast and practical
integer programming algorithm for dependence analysis," 1991.
https://doi.org/10.1145/125826.125848

### decide

**What you write:**

```lean
example : 2 + 2 = 4 := by decide
```

**What it builds:** `of_decide_eq_true (Eq.refl true)`

Evaluates a `Decidable` proposition by computation. The kernel
computes `decide (2 + 2 = 4)` to `true`, then uses the `Decidable`
machinery to extract a proof.

Only works for propositions with a `Decidable` instance.
`nativeDecide` does the same but uses compiled native code (faster,
larger trusted base).

### norm_cast

**What you write:**

```lean
example (n : Nat) : (n : Int) + 0 = (n : Int) := by norm_cast
```

**What it builds:** Normalizes casts between numeric types using
`@[norm_cast]` lemmas. Pushes casts inward/outward until the
expression is in normal form.

### ac_nf / acRfl

Associativity-commutativity normal form. Reorders terms in
commutative/associative operations to a canonical order, then
checks equality.

---

## 7. Unfolding Definitions

### unfold

**What you write:**

```lean
def double (n : Nat) := n + n

example : double 5 = 10 := by
  unfold double
  -- goal becomes: 5 + 5 = 10
  rfl
```

**What it builds:** Replaces a definition name with its body in the
goal. The proof term uses definitional equality (the kernel can see
through `unfold`).

### delta

Like `unfold`, but only performs delta-reduction (replacing a constant
with its definition). Does not simplify further.

### change / show

**What you write:**

```lean
example : 2 + 2 = 4 := by
  change 4 = 4
  rfl
```

**What it builds:** `Eq.refl 4`

Replaces the goal with a definitionally equal type. The kernel
verifies both types are the same. No proof term is needed for the
change itself.

`show` is the same: `show T` changes the goal to `T` if definitionally
equal.

---

## 8. Hypothesis Management

### have

**What you write:**

```lean
example (hp : P) (hpq : P -> Q) : Q := by
  have hq : Q := hpq hp
  exact hq
```

**What it builds:** `let hq : Q := hpq hp; hq`

Introduces a new term into the context. `have hq : Q := proof`
computes a proof of `Q` and binds it as `hq`. The new term is
available in subsequent tactics.

`have` erases the body (it is opaque in the context). `let` keeps
the body visible (transparent).

### let

Like `have`, but the definition is transparent in the context.
After `let x := 5`, the context knows `x = 5` and can unfold it.

### suffices

**What you write:**

```lean
example (hp : P) (hpq : P -> Q) : Q := by
  suffices h : P from hpq h
  exact hp
```

**What it builds:** `hpq hp`

`suffices h : T from body` says: "it suffices to prove `T`, because
given a proof of `T`, I can build the goal." This creates two
subgoals: (1) prove `T`, (2) in `body`, `h : T` is available.

### specialize

**What you write:**

```lean
example (h : forall n : Nat, n > 0 -> n >= 1) : 5 >= 1 := by
  specialize h 5
  -- h is now : 5 > 0 -> 5 >= 1
  apply h; omega
```

**What it builds:** Partially applies a universally quantified
hypothesis. `specialize h 5` replaces `h : forall n, ...` with
`h : ...` where `n` is now `5`.

### revert

**What you write:**

```lean
example (n : Nat) (h : n > 0) : n >= 1 := by
  revert h
  -- goal becomes: n > 0 -> n >= 1
  intro h; omega
```

**What it builds:** The inverse of `intro`. Moves a hypothesis from
the context back into the goal as an implication/universal.

`revert n` turns `n : Nat` in the context into `forall n : Nat, ...`
in the goal.

### clear

Removes a hypothesis from the context. This is used when a hypothesis
is no longer needed and clutters the proof state.

### rename_i

Renames inaccessible (auto-generated) names in the context.

### replace

**What you write:**

```lean
example (h : P) (hpq : P -> Q) : Q := by
  replace h := hpq h
  -- h is now : Q
  exact h
```

Replaces a hypothesis with a new one. `replace h := e` removes
the old `h` and adds a new `h` with the type of `e`.

### trivial

**What you write:**

```lean
example : True := by trivial
```

**What it builds:** Tries `rfl`, `assumption`, and `True.intro` in
sequence. A quick way to close simple goals.

**Term built:** `True.intro` (for `True` goals), or whatever
`assumption`/`rfl` would build.

### and_intros

**What you write:**

```lean
example (hp : P) (hq : Q) (hr : R) : P /\ Q /\ R := by
  refine ⟨?_, ?_, ?_⟩ <;> assumption
```

Recursively applies `And.intro` to split nested conjunctions.

### classical

**What you write:**

```lean
example (P : Prop) : P \/ Not P := by
  classical
  exact Classical.em P
```

Makes the law of excluded middle (`Classical.em`) available. After
`classical`, you can use non-constructive reasoning.

Under the hood, this opens access to the `Classical.choice` axiom,
one of Lean's three axioms. Without `classical`, Lean's logic is
constructive.

**Reference:** The law of excluded middle as an axiom in constructive
systems traces to Brouwer's rejection of it (1908) and Heyting's
formalization of intuitionist logic (1930). Lean follows the CIC
tradition of making it optional.

### false_or_by_contra

Setup for proof by contradiction. If the goal is `P`, changes it
to assume `Not P` and derive `False`. This is the tactic behind
Mathlib's `by_contra`.

```lean
example (n : Nat) (h : n > 0) : n != 0 := by
  false_or_by_contra
  omega
```

### fun_cases

Case-split on a function application. If the goal involves `f x`
where `f` is defined by pattern matching, `fun_cases` splits on
which branch of `f` applies.

### subst_vars / subst_eqs

`subst_vars` substitutes all equalities of the form `x = e` or
`e = x` in the context (where `x` is a free variable).

`subst_eqs` is similar but works on all equations simultaneously.

---

## 9. Control Flow

### first

**What you write:**

```lean
example : 1 + 1 = 2 := by
  first | rfl | simp | omega
```

Tries each tactic in order. Uses the first one that succeeds.

### try

**What you write:**

```lean
example : True := by
  try simp  -- if simp fails, that is ok
  trivial
```

Runs a tactic but does not fail if it does not work. `try t` =
`first | t | skip`.

### repeat / repeat'

Runs a tactic repeatedly until it fails.

### allGoals / anyGoals

`allGoals t` applies tactic `t` to every open goal.
`anyGoals t` applies `t` to at least one goal.

### <;> (seq focus)

```lean
constructor <;> assumption
```

Applies the tactic after `<;>` to ALL goals generated by the tactic
before it. Useful when multiple subgoals need the same treatment.

### focus

Focuses on a single goal. Subsequent tactics only see that goal.

### rotateLeft / rotateRight

Reorders the goal list. `rotateLeft n` moves the first `n` goals
to the end.

### done

Asserts that there are no remaining goals. Fails if any goals remain.

### sorry / admit

Placeholder. Axiomatically closes the goal without proof.
`sorry` produces a warning. Never use in finished proofs.

---

## 10. Classical Logic and Contradiction

### exfalso

**What you write:**

```lean
example (hp : P) (hnp : Not P) : Q := by
  exfalso
  exact hnp hp
```

**What it builds:** `False.elim (hnp hp)`

Changes the goal from `Q` to `False`. Since `False` implies anything
(`False.elim : False -> C`), proving `False` suffices for any goal.

### contradiction

**What you write:**

```lean
example (hp : P) (hnp : Not P) : Q := by
  contradiction
```

**What it builds:** `absurd hp hnp` (or `False.elim (hnp hp)`)

Searches the context for contradictory hypotheses (e.g., `h : P` and
`h' : Not P`, or `h : False`) and closes the goal.

### classical

Makes the law of excluded middle available. After `classical`, you
can use `Classical.em` and non-constructive reasoning.

### falseOrByContra

Setup for proof by contradiction. Changes the goal to assume its
negation and derive `False`.

---

## 11. Conversion Mode (conv)

`conv` lets you navigate inside a term and rewrite specific
subexpressions. Think of it as a cursor you move around the term.

```lean
example (a b : Nat) : (a + 0) * (b + 0) = a * b := by
  conv =>
    lhs           -- focus on left side of =
    rw [Nat.add_zero]  -- rewrite a + 0 to a
    -- but this rewrites both! Use congr + targeting:
  sorry
```

### conv navigation tactics

| Tactic | What it does |
|--------|-------------|
| `lhs` | Focus on left side of `=` |
| `rhs` | Focus on right side of `=` |
| `congr` | Descend into function and argument |
| `arg n` | Focus on the n-th argument |
| `ext x` | Introduce a variable (under a binder) |
| `enter [1, 2]` | Navigate to a nested position by index |
| `fun x =>` | Enter a function body |
| `pattern t` | Focus on subexpression matching `t` |

### conv transformation tactics

Inside `conv`, you can use:
- `rw [h]` - rewrite at the focused position
- `simp` - simplify at the focused position
- `unfold f` - unfold a definition
- `change t` - replace with definitionally equal term
- `whnf` - reduce to weak head normal form
- `delta f` - delta-reduce a constant
- `zeta` - zeta-reduce (unfold let bindings)
- `reduce` - full reduction

---

## 12. Extensionality and Congruence

### ext

**What you write:**

```lean
example (f g : Nat -> Nat) (h : forall x, f x = g x) :
    f = g := by
  ext x
  exact h x
```

**What it builds:** `funext (fun x => h x)`

Applies extensionality: to prove two functions are equal, prove they
agree on all inputs. To prove two structures are equal, prove their
fields are equal.

Under the hood, uses lemmas tagged `@[ext]`.

### congr

**What you write:**

```lean
example (h : a = b) : f a = f b := by
  congr
```

**What it builds:** `congrArg f h`

Congruence: if `a = b`, then `f a = f b`. `congr` reduces the goal
`f a = f b` to subgoals proving the arguments are equal.

### monotonicity

Proves monotonicity goals: if `a <= b` and `f` is monotone, then
`f a <= f b`.

---

## 13. Generalization

### generalize

**What you write:**

```lean
example : 2 + 2 = 4 := by
  generalize 2 = n
  -- goal becomes: n + n = 4 ... (too general, just for illustration)
  sorry
```

Replaces a concrete term with a fresh variable. Makes the goal more
general. Useful before `induction` when you need a more general
induction hypothesis.

### revert + intro (generalize/specialize cycle)

`revert` then `intro` is a way to restructure the context. `revert`
generalizes (moves to goal), `intro` specializes (moves to context).

---

## 14. Decision Procedures

### omega

Complete decision procedure for linear arithmetic over `Nat` and `Int`.
Handles `+`, `-`, `*` (by constant), `<`, `<=`, `=`, `>=`, `>`, `%`,
`/` (by constant).

### decide / nativeDecide

Evaluate a `Decidable` proposition by computation. `decide` uses the
kernel evaluator, `nativeDecide` uses compiled code.

### grind

SMT-like tactic combining congruence closure, arithmetic, and
rewriting. More powerful than `simp` for certain problems. Can use
hints: `grind [h1, h2]`.

### linarith / lia

Linear arithmetic. `linarith` proves linear inequality goals.
`lia` is an alias. In Lean 4.29+, these are implemented via `grind`.

### bv_decide / bv_omega

Decision procedures for bitvector arithmetic (`BitVec n`).
`bv_decide` uses a SAT solver. `bv_omega` combines `omega` with
bitvector reasoning.

### ac_rfl / ac_nf

Associativity-commutativity reasoning.

`ac_rfl` closes a goal `a = b` when `a` and `b` are equal up to
reordering under associative-commutative operations.

`ac_nf` normalizes terms into AC-canonical form without closing
the goal.

### cbv

Call-by-value evaluation. Fully reduces the goal using the kernel's
evaluator. More aggressive than `dsimp` (which only does definitional
simplification).

```lean
example : Nat.factorial 5 = 120 := by native_decide
```

---

## 15. Debugging and Inspection

### traceState

Prints the current goal state to the info view. Does not change the
proof.

### showTerm

```lean
example : True := by showTerm trivial
```

Shows the term that a tactic produces. Useful for understanding what
a tactic actually builds.

### dbgTrace

Prints a debug message during tactic execution.

---

## 16. Search Tactics

### exact?

**What you write:**

```lean
example (hp : P) (hpq : P -> Q) : Q := by
  exact?
  -- suggests: exact hpq hp
```

Searches for a single term that closes the goal. Searches the context
and the environment (imported lemmas).

### apply?

Searches for a lemma whose conclusion matches the goal. Suggests an
`apply` call.

### rw? / rewrites?

Searches for an equation that can rewrite part of the goal.

---

## 17. Instance and Type Inference

### infer_instance

**What you write:**

```lean
example : Inhabited Nat := by infer_instance
```

**What it builds:** Delegates to typeclass resolution. Lean searches
for a registered instance of the typeclass and returns it.

---

## Summary: The Construction Analogy

| Tactic | Term-mode equivalent | What you are building |
|--------|---------------------|----------------------|
| `intro x` | `fun x =>` | Take a function argument |
| `exact e` | `e` | Return a value |
| `apply f` | `f ?_ ?_` | Call a function, leaving args as TODOs |
| `refine e` | `e` with `?_` holes | Partial term with blanks |
| `constructor` | `T.mk ?_ ?_` | Build a struct/pair |
| `left` | `Or.inl ?_` | Pick first constructor |
| `right` | `Or.inr ?_` | Pick second constructor |
| `exists w` | `Exists.intro w ?_` | Provide a witness |
| `cases h` | `match h with ...` | Pattern-match on a value |
| `induction n` | `Nat.rec ?_ ?_ n` | Apply the recursor |
| `rfl` | `Eq.refl _` | Reflexivity proof |
| `rw [h]` | `h >> Eq.refl _` | Substitute and reflect |
| `simp` | chain of rewrites | Automated rewrite chain |
| `omega` | arithmetic proof | Decision procedure output |
| `decide` | `of_decide_eq_true rfl` | Computational evaluation |
| `have h := e` | `let h := e; ...` | Bind an intermediate result |
| `suffices h from e` | `e` where `h` is proved below | Top-down construction |
| `exfalso` | `False.elim ?_` | Promise to derive absurdity |
| `contradiction` | `absurd h1 h2` | Find contradictory terms |
| `ext x` | `funext (fun x => ...)` | Prove functions equal pointwise |
| `congr` | `congrArg f ?_` | Reduce f a = f b to a = b |
| `revert x` | (undo `intro`) | Move variable back to goal |
| `clear h` | (drop unused binding) | Remove from context |
| `trivial` | `True.intro` or `rfl` | Close simple goals |
| `split` | case-split on match/if | Branch on definition |
| `generalize e = x` | (replace concrete with variable) | Make goal more general |
| `classical` | (enable excluded middle) | Enter classical logic |
| `subst h` | (substitute equality) | Eliminate a variable |
| `injection h` | (constructor injectivity) | Extract from Nat.succ = Nat.succ |
| `grind` | (SMT-like automation) | Congruence + arithmetic |
| `ac_rfl` | (AC normalization) | Reorder commutative ops |
| `sorry` | `sorryAx _` | Axiom placeholder (unsound) |

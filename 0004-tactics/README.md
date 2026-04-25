# 0004 - Tactics

## Goal

Learn tactic-mode proofs. Instead of constructing proof terms
directly, you use commands (tactics) that transform the proof state
step by step. Understand the LCF architecture that makes tactics
safe, and how tactics relate to proof search in logic.

A separate file `TACTICS_REFERENCE.md` contains the exhaustive list
of all built-in tactics with their Curry-Howard explanations.

**Lore:**

- [Why "tactic"?](../lore/why-tactic.md) - From Milner's LCF (1972)
- [Why inl/inr?](../lore/why-inl-inr.md) - Category theory coproduits
- [What tactics actually build](../lore/what-tactics-build.md) -
  Step-by-step term construction
- [What omega does](../lore/what-omega-does.md) - The full pipeline
- [What simp does](../lore/what-simp-does.md) - The rewriting engine

---

## The LCF Architecture: Why Tactics Are Safe

Lean's tactic framework follows the **LCF architecture**, designed
by Robin Milner for the Edinburgh LCF system (1972). The key insight:
tactics are untrusted code that generates proof terms, and the
kernel checks every generated term. A buggy tactic cannot produce a
false proof.

The architecture has two layers:

1. **The kernel** (trusted, small): checks that a term has a given
   type. It implements the typing rules of CIC. If the kernel
   accepts `h : P`, then `P` is genuinely proved.

2. **Tactics** (untrusted, large): programs that construct proof
   terms. They can be arbitrarily complex, use heuristics, call
   external solvers, or even contain bugs. The kernel verifies
   their output.

This separation means you can add new tactics without increasing
the trusted computing base. Mathlib has hundreds of custom tactics.
None of them can introduce unsoundness because every proof term
they produce is checked by the kernel.

In the original LCF, the kernel was an abstract type `thm` whose
only constructors were the inference rules. You could not forge a
`thm` value without applying a valid rule. Lean takes a different
but equivalent approach: the kernel is a separate type-checker that
validates the fully elaborated term.

**Reference:** Milner, R. (1972). "Logic for Computable Functions:
Description of a Machine Implementation." Stanford AI Memo 169.

**Reference:** Gordon, M., Milner, R., and Wadsworth, C. (1979).
"Edinburgh LCF: A Mechanised Logic of Computation." LNCS 78.
Springer.

## Forward vs. Backward Reasoning

There are two fundamental directions for constructing proofs:

**Forward reasoning** (term mode): start from what you know
(hypotheses) and derive new facts until you reach the goal. This is
how you write proof terms directly:

```lean fromFile:Examples.lean#forward_reasoning
-- Start from hp and hpq, derive the goal
theorem ex1 (hp : P) (hpq : P -> Q) : Q :=
  hpq hp    -- apply what we know to get Q
```

**Backward reasoning** (tactic mode): start from the goal (what you
want to prove) and reduce it to simpler subgoals until everything is
trivially true. This is what tactics do:

```lean fromFile:Examples.lean#backward_reasoning
-- Start from the goal Q, reduce it
theorem ex2 (hp : P) (hpq : P -> Q) : Q := by
  apply hpq    -- Q reduces to subgoal P
  exact hp     -- P is in the context
```

Backward reasoning corresponds to **goal-directed proof search**.
Given a goal `G`, you look for rules whose conclusion matches `G`
and generate their premises as new subgoals. This is the strategy
used by Prolog, by the `auto` tactic in Coq, and by Lean's `aesop`.

Most real proofs mix both directions: backward reasoning to set up
the proof structure, forward reasoning (`have`) to derive
intermediate facts.

**Reference:** The forward/backward distinction goes back to
Robinson's resolution principle (1965) and Kowalski's work on logic
programming (1974). Paulson adapted it for tactics in Isabelle
(1989).

---

## Term Mode vs Tactic Mode

```lean fromFile:Examples.lean#term_vs_tactic_mode
-- Term mode: construct the proof directly
theorem p_implies_p_term (P' : Prop) : P' -> P' :=
  fun hp => hp

-- Tactic mode: use `by` to enter tactic mode
theorem p_implies_p_tactic (P' : Prop) : P' -> P' := by
  intro hp
  exact hp
```

Both modes produce the same thing: a term of the right type.
Tactic mode is just a different way to build that term, step by
step. You can verify this with `#print p_implies_p_tactic`: the
output is `fun hp => hp`, identical to the term-mode version.

---

## The Curry-Howard View of Tactics

Recall from course 0003: propositions are types, proofs are terms.
A goal `P -> Q` is a function type. You need to construct a
function.

Tactic mode is a **term construction machine**. At each step, you
have:

- A **goal**: the type of the term you still need to build
- A **context**: the terms (hypotheses) you already have

Each tactic transforms the goal by partially building the term.

Formally, a tactic takes a **proof state** (a list of goals, each
with a context and a target type) and produces a new proof state
with (hopefully) simpler goals. When all goals are discharged, the
accumulated transformations yield a complete proof term.

In Lean 4, tactics are monadic programs in the `TacticM` monad.
They have access to the full metavariable context (the "proof
state") and can create, assign, and manipulate metavariables.
A metavariable `?m : T` represents an unfilled hole of type `T`.
When a tactic assigns `?m := t`, it fills the hole. When all
metavariables are assigned, the proof term is complete.

**Example, side by side:**

```lean fromFile:Examples.lean#curry_howard_side_by_side
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
```

The tactic proof produces exactly the same term as the term-mode
proof. You can verify this with `#print ex_tactic`.

---

## Essential Tactics: What They Build

### intro / intros

The goal is a function type `A -> B`. `intro h` says: "take a
function argument `h : A`." The goal becomes `B`.

This is exactly `fun h =>` in term mode.

```lean
example (P Q : Prop) : P -> Q -> P := by
  intro hp _hq   -- fun hp _hq =>
  exact hp        -- hp
```

**Term built:** `fun hp _hq => hp`

### exact

Provide a term whose type matches the goal exactly. This closes the
goal. Think of it as the "return statement."

```lean fromFile:Examples.lean#exact_tactic
example (hp : P) : P := by
  exact hp
```

**Term built:** `hp`

### apply

You have `f : A -> B` and the goal is `B`. `apply f` says: "I will
call `f` to produce a `B`, but I still need an `A`." The goal becomes
`A` (the missing argument).

```lean fromFile:Examples.lean#apply_tactic
example (hpq : P -> Q) (hp : P) : Q := by
  apply hpq    -- hpq ?_
  exact hp     -- hpq hp
```

**Term built:** `hpq hp`

### refine

Like `exact`, but allows holes (`?_`). Each hole becomes a new
subgoal.

```lean
example (hp : P) (hq : Q) : P /\ Q := by
  refine And.intro ?_ ?_   -- And.intro ?_ ?_
  exact hp                  -- And.intro hp ?_
  exact hq                  -- And.intro hp hq
```

**Term built:** `And.intro hp hq`

### constructor

The goal is a structure or inductive with one constructor. `constructor`
applies that constructor, creating one subgoal per argument.

For `P /\ Q`, the constructor is `And.intro : P -> Q -> P /\ Q`.

```lean
example (hp : P) (hq : Q) : P /\ Q := by
  constructor      -- And.intro ?_ ?_
  . exact hp       -- And.intro hp ?_
  . exact hq       -- And.intro hp hq
```

**Term built:** `And.intro hp hq`

### left / right

The goal is a sum type with two constructors (like `P \/ Q`).
`left` picks `Or.inl`, `right` picks `Or.inr`.

```lean
example (hp : P) : P \/ Q := by
  left         -- Or.inl ?_
  exact hp     -- Or.inl hp
```

**Term built:** `Or.inl hp`

### exists

Provides the witness for an existential. `exists a` is
`refine Exists.intro a ?_`.

```lean fromFile:Examples.lean#exists_tactic
example : Exists (fun n : Nat => n > 0) := by
  exists 1     -- Exists.intro 1 ?_ ... then omega closes the proof
```

### cases

You have `h : P \/ Q` (a sum type). `cases h` pattern-matches on it.
Each constructor becomes a branch.

```lean
example (h : P \/ Q) : Q \/ P := by
  cases h with
  | inl hp => right; exact hp    -- Or.inr hp
  | inr hq => left; exact hq    -- Or.inl hq
```

**Term built:** `match h with | Or.inl hp => Or.inr hp | Or.inr hq => Or.inl hq`

### obtain / rcases

Recursive destructuring. `obtain` extracts components from existentials
and conjunctions in one step.

```lean
example (h : P /\ (Q /\ R)) : R := by
  obtain ⟨_, _, hr⟩ := h    -- let ⟨_, _, hr⟩ := h
  exact hr
```

**Term built:** `h.2.2`

### induction

Applies the recursor of an inductive type. For `Nat`, this is
`Nat.rec`: provide a base case and a step case (with the induction
hypothesis).

```lean fromFile:Examples.lean#induction_tactic
theorem zero_add (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ n ih => rw [Nat.add_succ, ih]
```

**Term built:** `Nat.rec (motive := ...) rfl (fun n ih => ...) n`

This is the computational content of mathematical induction. The
recursor is the universal property of the natural numbers, first
characterized by Dedekind (1888) and axiomatized by Peano (1889).

**Reference:** Giuseppe Peano, "Arithmetices principia, nova methodo
exposita," 1889.

### rfl

Both sides of `=` reduce to the same value by computation. `rfl`
constructs `Eq.refl`.

```lean fromFile:Examples.lean#rfl_tactic
example : 2 + 2 = 4 := by rfl
```

**Term built:** `Eq.refl 4`

This only works when both sides are **definitionally** equal (the
kernel can compute them to the same normal form without any lemmas).

### rw / rewrite

Replaces occurrences of one side of an equation with the other.
`rw [h]` where `h : a = b` replaces `a` with `b` in the goal.

```lean fromFile:Examples.lean#rw_tactic
example (h : a = b) : a + c = b + c := by
  rw [h]    -- goal becomes b + c = b + c, closed by rfl
```

**Term built:** Uses `Eq.mpr` (transport along an equality) to
transform the proof obligation. Under the hood:
`Eq.mpr (congrArg (. + c) h) (Eq.refl (b + c))`

`rw [<- h]` rewrites right-to-left (replaces `b` with `a`).

### have / let

Introduce a new term into the context. `have` erases the body
(opaque). `let` keeps it visible (transparent).

```lean fromFile:Examples.lean#have_tactic
example (hp : P) (hpq : P -> Q) : Q := by
  have hq : Q := hpq hp    -- let hq := hpq hp
  exact hq
```

**Term built:** `let hq := hpq hp; hq`

### exfalso

Changes the goal to `False`. Since `False -> C` for any `C`
(`False.elim`), proving `False` suffices.

```lean fromFile:Examples.lean#exfalso_tactic
example (hp : P) (hnp : Not P) : Q := by
  exfalso           -- goal becomes False
  exact hnp hp      -- hnp hp : False
```

**Term built:** `False.elim (hnp hp)`

### contradiction

Searches the context for contradictory hypotheses and closes the goal.

```lean fromFile:Examples.lean#exfalso_tactic
example (hp : P) (hnp : Not P) : Q := by
  exfalso           -- goal becomes False
  exact hnp hp      -- hnp hp : False
```

**Term built:** `absurd hp hnp`

### ext

Proves two functions (or structures) are equal by proving they agree
on all inputs (or all fields).

```lean fromFile:Examples.lean#ext_tactic
example (f g : Nat -> Nat) (h : forall x, f x = g x) :
    f = g := by
  ext x         -- fun x => ...
  exact h x
```

**Term built:** `funext (fun x => h x)`

Uses function extensionality, which in Lean follows from `propext`
and `Quot.sound`.

### congr

Proves `f a = f b` by reducing to `a = b`.

**Term built:** `congrArg f (proof that a = b)`

### symm / calc

`symm` flips an equality: `Eq.symm h`. `calc` chains equalities
via `Eq.trans`:

```lean fromFile:Examples.lean#symm_calc_tactic
example (h1 : a = b) (h2 : b = c) : a = c := by
  calc a = b := h1
    _ = c := h2
```

**Term built:** `Eq.trans h1 h2`

---

## Automation Tactics: What They Do Under the Hood

### simp

A **term rewriting engine**. Repeatedly applies lemmas tagged
`@[simp]` (left-to-right) until no more apply.

**What it builds:** A chain of `Eq.trans`, `Eq.mpr`, and congruence
lemmas. Each step is a verified rewrite.

**Reference:** Term rewriting systems are studied in depth in
Baader and Nipkow, "Term Rewriting and All That," Cambridge
University Press, 1998.

Variants:
- `simp only [h1, h2]` - use only the listed lemmas
- `simp [h]` - add `h` to the simp set
- `simp at h` - simplify a hypothesis
- `simp_all` - simplify everything
- `simp?` - suggest which lemmas were used

### omega

A **decision procedure** for linear arithmetic over `Nat` and `Int`.

**What it handles:** `+`, `-`, `*` by a constant, `/` by a constant,
`%` by a constant, and all comparisons (`<`, `<=`, `=`, `>=`, `>`).

**What it does NOT handle:** multiplication of two variables (nonlinear
arithmetic).

**The full pipeline under the hood:**

**Step 1: Proof by contradiction.** omega does not build a direct
proof. It negates the goal and tries to derive `False`. If the goal
is `n >= 3`, omega adds `n <= 2` as a hypothesis and searches for a
contradiction.

**Step 2: Cast everything to Int.** All Nat values are cast to Int.
For each Nat variable `n`, the constraint `0 <= n` is automatically
added (Nat is non-negative). All comparisons are normalized to the
canonical form:

```
c0 + c1*x1 + c2*x2 + ... + cn*xn >= 0
```

For example, given `h : n >= 5` and the negated goal `n <= 2`:

```
n - 5 >= 0      (from h)
2 - n >= 0      (from negated goal)
n >= 0          (Nat non-negativity)
```

**Step 3: Solve equalities by substitution.** If the system contains
exact equalities (like `2*a + b = 7`), omega eliminates variables.

For "easy" equalities where some coefficient is +/-1, it substitutes
directly. For "hard" equalities (all coefficients > 1), it uses a
**balanced modular reduction** trick: given the equality, pick the
smallest coefficient `m`, compute all coefficients modulo `m+1` using
balanced mod (values in `[-(m+1)/2, m/2]`), and introduce a new
variable. This creates an equality with a +/-1 coefficient, which can
then be solved directly. The process terminates because the pair
`(minCoeff, maxCoeff)` strictly decreases lexicographically.

**Step 4: Eliminate variables via Fourier-Motzkin.** For the remaining
inequalities, omega picks a variable and combines all its lower bounds
with all its upper bounds. For our example:

```
n >= 5     (lower bound on n)
n <= 2     (upper bound on n)
```

Combining: `(n - 5) + (2 - n) >= 0` simplifies to `-3 >= 0`, which
is `False`. Contradiction found.

The variable selection heuristic prefers "exact" eliminations (where
one side has coefficient +/-1) to avoid blowup in the number of
generated constraints.

**Step 5: Build the proof term.** omega tracks every derivation step
in a justification tree. Once `False` is found, it walks the tree
backward and emits a chain of Lean lemma applications:

```
False
  <- impossible constraint detected
  <- linear combination of constraints
  <- normalization (divide by GCD, tighten bounds)
  <- original hypotheses
```

The proof term is composed of lemmas like `combo_sat'` (linear
combination), `tidy_sat` (normalization), and
`Constraint.not_sat'_of_isImpossible` (deriving False).

**Nat subtraction, the tricky case.** `(a - b : Nat)` in Lean is 0
when `a < b` (truncated subtraction). omega records a disjunction:

- Either `b <= a` and the result is `a - b`
- Or `a < b` and the result is `0`

It first tries to derive a contradiction without splitting. If it
cannot, it splits and tries both branches recursively.

**Algorithm:** The Omega test, a decision procedure for Presburger
arithmetic (first-order theory of natural numbers with addition). The
core algorithm uses Fourier-Motzkin variable elimination for
inequalities and balanced modular arithmetic for equalities.

**Reference:** William Pugh, "The Omega Test: a fast and practical
integer programming algorithm for dependence analysis,"
Communications of the ACM, 1992.
https://doi.org/10.1145/125826.125848

**Reference:** The Fourier-Motzkin elimination method dates to
Joseph Fourier (1826) and Theodore Motzkin (1936). See Schrijver,
"Theory of Linear and Integer Programming," Wiley, 1986.

### decide

Evaluates a `Decidable` proposition by computation. The kernel
computes `decide P` to `true`, then uses the `Decidable` machinery
to extract a proof.

```lean fromFile:Examples.lean#decide_tactic
example : 2 + 2 = 4 := by decide
```

**Term built:** `of_decide_eq_true (Eq.refl true)`

Only works for propositions with a `Decidable` instance.
`nativeDecide` does the same using compiled native code (faster for
large computations, but with a larger trusted computing base).

### norm_cast

Normalizes casts between numeric types. Pushes coercions
inward/outward using `@[norm_cast]` lemmas until the expression is
in normal form.

### grind

An SMT-like tactic combining congruence closure, arithmetic, and
rewriting. More powerful than `simp` for certain problems.

**Reference:** Congruence closure was introduced by Nelson and Oppen,
"Fast Decision Procedures Based on Congruence Closure," Journal of
the ACM, 1980.

---

## Tactic Combinators

```lean fromFile:Examples.lean#tactic_combinators
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
```

---

## Category Theory Perspective

**The tactic state as a morphism-building problem.** A proof state
`Γ ⊢ G` — context `Γ`, goal `G` — is a request to construct a
morphism `[[Γ]] → G` in the free cartesian closed category generated
by the hypotheses. Each tactic transforms this into a
sub-composition problem.

| Tactic | Lambda calculus | Category theory |
|--------|-----------------|-----------------|
| `intro h` | `fun h =>` | Right adjunct (currying) |
| `apply f` | `f ?_` (partial application) | Pre-composition with `f` |
| `exact h` | identity | The identity morphism |
| `constructor` | `And.intro _ _` | Universal property of product |
| `left` / `right` | `Or.inl` / `Or.inr` | Coproduct injections |
| `cases h` | `match h with` | Copairing (universal property of coproduct) |
| `rfl` | `Eq.refl` | Diagonal `Δ : A → A × A` specialised to `=` |
| `ext` | `funext` | Pointwise equality = no proper epimorphisms in **Set** |
| `calc` | `Eq.trans` | Composition of morphisms |
| `simp` | term rewriting | Congruence closure (quotient category) |

**Cut elimination and normalization.** A **cut** in Gentzen's
sequent calculus (1935) is the composition rule: from `Γ ⊢ A` and
`Γ, A ⊢ B`, derive `Γ ⊢ B`. Categorically, a cut is composition of
morphisms. Gentzen's **Hauptsatz** (cut-elimination theorem) says
every cut can be removed, yielding an analytic proof. In type theory
this is **normalization**: every proof term reduces to a beta-eta
normal form. The categorical proof is that the free CCC has a
decidable equality on morphisms, which follows from confluence and
strong normalization of reduction.

**The Yoneda lemma and `exact`.** The tactic `exact h` closes a
goal `P` when `h : P` is in the context. This uses the **Yoneda
embedding** principle: a type (object) is fully determined by its
"incoming hom-sets". More directly, the **representability**
viewpoint says that proving `P` is the same as producing a global
element `⊤ → P`. The Yoneda lemma underpins `funext` and `ext`:
two morphisms are equal iff they agree on all generalized elements.

**Adjunctions and decision procedures.** Automated tactics like
`omega` correspond to decidability of hom-sets in certain quotient
categories. The theory of linear arithmetic (Presburger arithmetic)
is the equational theory of ordered abelian groups; its hom-sets are
decidable by the Omega algorithm (Pugh, 1992). `simp` implements
**congruence closure**, computing the least congruence relation
containing the given equations — this is the **quotient** of the
term category by those equations. Decidability results in proof
theory and category theory are two sides of the same coin.

**Reference:** Seely, R.A.G. (1984). "Locally cartesian closed
categories and type theory." *Mathematical Proceedings of the
Cambridge Philosophical Society* 95. Establishes that dependent type
theory is the internal language of locally cartesian closed
categories.

**Reference:** Gentzen, G. (1935). "Untersuchungen über das logische
Schließen." *Mathematische Zeitschrift* 39. The original cut-
elimination paper, whose categorical meaning was clarified by
Lambek's work three decades later.

---

## Math Track

Tactic proofs mirror how mathematicians think: "assume P, then by
hypothesis we have Q, therefore...". The tactic state shows you
exactly what you know (hypotheses) and what you need to show (goal).

When a mathematician says "assume P holds", they are doing exactly
what `intro hp` does: taking an arbitrary proof of P and working
with it. When they say "by hypothesis, we are done", that is
`exact`.

When they say "by induction on n", they are applying the recursor
(`Nat.rec`), which requires a base case and a step with an
induction hypothesis.

### The sequent calculus connection

The tactic state can be read as a **sequent**:

```
hp : P, hq : Q |- R
```

This means: "given proofs of P and Q, we need to prove R." This is
exactly a sequent in Gentzen's sequent calculus (1935). Each tactic
corresponds to a sequent calculus rule applied **bottom-up** (from
conclusion to premises):

| Tactic | Sequent calculus rule |
|--------|---------------------|
| `intro hp` | Right introduction for -> |
| `apply hpq` | Left elimination for -> (cut with hpq) |
| `constructor` | Right introduction for /\ |
| `left` / `right` | Right introduction for \/ |
| `cases h` | Left elimination for \/ |
| `exact hp` | Identity rule (axiom) |
| `exfalso` | Weakening to False on the right |

The sequent calculus has the **cut elimination theorem** (Gentzen's
Hauptsatz): every proof with cuts can be transformed into a
cut-free proof. In type theory terms, this corresponds to
normalization: every proof term reduces to a normal form. Cut
elimination is one of the deepest results in proof theory.

**Reference:** Gentzen, G. (1935). "Untersuchungen uber das
logische Schliessen." Mathematische Zeitschrift. Introduced both
natural deduction and the sequent calculus.

## CS Track

Tactics are a term-construction DSL. The tactic state is a
partially-built program:

- The **goal** is the return type you still need to produce
- The **context** is the set of variables in scope
- Each tactic is a step in building the program

| Tactic | Program analogy |
|--------|----------------|
| `intro x` | Accept a function argument |
| `exact e` | Return a value |
| `apply f` | Call function `f`, leaving args as TODOs |
| `constructor` | Build a struct/tuple |
| `cases h` | Pattern-match on a sum type |
| `induction n` | Structural recursion |
| `have h := e` | Bind an intermediate variable |

When all goals are closed, Lean has a complete term. The tactic
block compiles down to exactly the same lambda term you would have
written by hand. Tactics are just an interactive way to write it.

### Metavariables and elaboration

Under the hood, the tactic framework uses **metavariables**
(unification variables). When you write `by`, Lean creates a
metavariable `?m` of the goal type. Each tactic assigns or
transforms metavariables:

```
-- Starting state: need ?m : P -> Q -> P
intro hp     -- ?m := fun hp => ?m1     (new ?m1 : Q -> P)
intro _hq    -- ?m1 := fun _hq => ?m2   (new ?m2 : P)
exact hp     -- ?m2 := hp               (done)
-- Result: ?m = fun hp _hq => hp
```

This is the same mechanism the elaborator uses for type inference.
Implicit arguments are metavariables that unification fills in.
Tactics are essentially a user-facing interface to the same
metavariable machinery.

### Decidability and automation

Some classes of propositions can be proved automatically by
**decision procedures**: algorithms that always terminate and
always give the correct yes/no answer.

| Tactic | Decides | Theory | Complexity |
|--------|---------|--------|------------|
| `decide` | `Decidable` instances | Computation | Depends on instance |
| `omega` | Linear arithmetic (Nat, Int) | Presburger arithmetic | Doubly exponential (worst case) |
| `norm_num` | Numeric equalities/inequalities | Ground arithmetic | Polynomial |
| `simp` | Equational theories | Term rewriting | Depends on lemma set |
| `aesop` | First-order goals | Tableau search | Semi-decidable |

A decision procedure for a theory T is an algorithm that, given
any sentence in T, determines whether it is true or false. Tarski
(1951) showed that the theory of real closed fields is decidable.
Presburger (1929) showed that integer arithmetic with addition (but
not multiplication) is decidable. On the other hand, Godel (1931)
showed that arithmetic with both addition and multiplication is
undecidable (incompleteness). This is why `omega` handles `+` but
not general `*`.

**Reference:** Presburger, M. (1929). "Uber die Vollstandigkeit
eines gewissen Systems der Arithmetik ganzer Zahlen, in welchem die
Addition als einzige Operation hervortritt." Comptes Rendus du
Premier Congres de Mathematiciens des Pays Slaves.

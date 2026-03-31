# What omega Does

`omega` is a decision procedure for linear arithmetic over `Nat` and
`Int`. Here is the full pipeline of what happens when you write
`by omega`.

## Step 1: Proof by Contradiction

omega does not build a direct proof. It negates the goal and tries
to derive `False`.

If the goal is `n >= 3`, omega adds `n <= 2` as a hypothesis and
searches for a contradiction with the existing hypotheses.

## Step 2: Cast Everything to Int

All Nat values are cast to Int. For each Nat variable `n`, the
constraint `0 <= n` is automatically added (Nat is non-negative).
All comparisons are normalized to the canonical form:

```
c0 + c1*x1 + c2*x2 + ... + cn*xn >= 0
```

Nat subtraction `(a - b : Nat)` is tricky because it truncates to 0
when `a < b`. omega records a disjunction:
- Either `b <= a` and the result is `a - b`
- Or `a < b` and the result is `0`

## Step 3: Solve Equalities

If the system has equalities like `2*a + b = 7`:

**Easy case:** Some coefficient is +/-1. Substitute directly and
eliminate the variable.

**Hard case:** All coefficients > 1. Use **balanced modular
reduction**: pick the smallest coefficient `m`, compute all
coefficients modulo `m+1` using balanced mod (values in
`[-(m+1)/2, m/2]`), and introduce a new variable. This creates
an equality with a +/-1 coefficient. Repeat.

Termination is guaranteed because the pair `(minCoeff, maxCoeff)`
strictly decreases lexicographically at each step.

## Step 4: Eliminate Variables (Fourier-Motzkin)

For the remaining inequalities, pick a variable and combine all
its lower bounds with all its upper bounds:

```
n >= 5     (lower bound)
n <= 2     (upper bound)
```

Combining: `(n - 5) + (2 - n) >= 0` simplifies to `-3 >= 0`. This
is `False`. Contradiction found.

Variable selection heuristic: prefer "exact" eliminations where one
side has coefficient +/-1 (avoids blowup in generated constraints).

## Step 5: Build the Proof Term

omega tracks every derivation step in a justification tree. Once
`False` is found, it walks backward and emits Lean lemma applications:

```
False
  <- impossible constraint
  <- linear combination of constraints
  <- normalization (divide by GCD, tighten bounds)
  <- original hypotheses
```

## What omega Handles

- `+`, `-`, `*` by a literal constant
- `/` by a literal, `%` by a literal
- All comparisons: `<`, `<=`, `=`, `>=`, `>`, `!=`
- Nat and Int (including truncated Nat subtraction)
- Divisibility (`k | n`)

## What omega Does NOT Handle

- Multiplication of two variables (`n * m`)
- Nonlinear arithmetic
- Quantifiers

## The Algorithm

The Omega test, by William Pugh. It is a decision procedure for
Presburger arithmetic (first-order theory of natural numbers with
addition, named after Mojzesz Presburger who proved its decidability
in 1929).

The core uses Fourier-Motzkin variable elimination for inequalities
(Joseph Fourier, 1826; Theodore Motzkin, 1936) and balanced modular
arithmetic for equalities (Pugh, 1992).

Lean's implementation does not include the "dark shadow" and "grey
shadow" extensions from Pugh's full algorithm, so it is technically
incomplete for some edge cases. In practice, this almost never
matters.

## References

- William Pugh, "The Omega Test: a fast and practical integer
  programming algorithm for dependence analysis," Communications
  of the ACM, 1992. https://doi.org/10.1145/125826.125848
- Mojzesz Presburger, "Uber die Vollstandigkeit eines gewissen
  Systems der Arithmetik ganzer Zahlen, in welchem die Addition als
  einzige Operation hervortritt," Comptes Rendus du I Congres des
  Mathematiciens des Pays Slaves, 1929.
- Alexander Schrijver, "Theory of Linear and Integer Programming,"
  Wiley, 1986 (for Fourier-Motzkin elimination).

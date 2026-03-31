# What simp Does

`simp` is a **term rewriting engine**. It repeatedly applies lemmas
tagged `@[simp]` (left-to-right) until no more apply.

## The Algorithm

1. Collect the simp set: all lemmas tagged `@[simp]` plus any
   explicitly provided lemmas (`simp [h1, h2]`).

2. Traverse the goal term bottom-up.

3. At each subterm, try to match the left-hand side of each simp
   lemma. If a match is found, replace the subterm with the
   right-hand side.

4. Repeat until no more lemmas apply (a fixed point).

5. Build the proof: a chain of `Eq.trans` applications, one per
   rewrite step.

## What the Proof Looks Like

```lean
example (n : Nat) : n + 0 = n := by simp
```

Under the hood, simp finds the lemma `Nat.add_zero : n + 0 = n`
and produces:

```lean
Nat.add_zero n
```

For a multi-step simplification:

```lean
example (xs : List Nat) : (xs ++ []).reverse.reverse = xs := by simp
```

simp chains together:
1. `List.append_nil : xs ++ [] = xs`
2. `List.reverse_reverse : xs.reverse.reverse = xs`

The proof term is `Eq.trans (congrArg ...) (List.reverse_reverse xs)`
or similar.

## Variants

- `simp only [h1, h2]`: use ONLY the listed lemmas (ignore global
  `@[simp]` set). More predictable.
- `simp [h]`: add `h` to the simp set.
- `simp at h`: simplify hypothesis `h` instead of the goal.
- `simp_all`: simplify goal AND all hypotheses.
- `simp?`: run simp, then suggest the minimal set of lemmas used.
  Useful for replacing `simp` with `simp only [...]`.
- `dsimp`: only apply **definitional** simplifications (beta
  reduction, let unfolding, projections). No lemmas. Faster.
- `simpa`: `simp` then `assumption`. Common finishing pattern.

## Confluence and Termination

The simp set should ideally be:
- **Confluent**: the order of applying lemmas does not matter
  (the result is the same).
- **Terminating**: rewriting always reaches a normal form.

In practice, Mathlib's simp set is not perfectly confluent, but it
is close enough. Bad simp lemmas (like `a = b` and `b = a` together)
cause infinite loops. This is why `simp` lemmas should always
simplify (reduce complexity).

## The @[simp] Attribute

A lemma should be tagged `@[simp]` when:
- The left-hand side is "simpler" than the right-hand side
- It always makes progress (does not loop)
- It is generally useful (not too specialized)

```lean
@[simp] theorem add_zero (n : Nat) : n + 0 = n := ...
@[simp] theorem mul_one (n : Nat) : n * 1 = n := ...
```

## References

- The theory of term rewriting is covered in Franz Baader and Tobias
  Nipkow, "Term Rewriting and All That," Cambridge University Press,
  1998. https://doi.org/10.1017/CBO9781139172752
- The simpifier in interactive theorem provers originates from the
  Boyer-Moore theorem prover (1979) and was refined in Isabelle
  (Nipkow, 1989) and HOL Light (Harrison, 1996).
- For Lean's implementation, see the source at
  `src/lean/Lean/Meta/Tactic/Simp/` in the Lean 4 repository.

# Why inl/inr?

`inl` and `inr` stand for **in**jection **l**eft and **in**jection
**r**ight. They come from category theory.

## The Coproduct

`P \/ Q` is a **coproduct** (also called a sum type). In category
theory, the coproduct `A + B` is defined by two morphisms:

```
        inl         inr
  A ---------> A + B <--------- B
```

`inl` and `inr` are **injections** in the mathematical sense:
functions that embed `A` (resp. `B`) into `A + B` without losing
information. Every element of `A + B` came from either `A` (via
`inl`) or `B` (via `inr`), and you can always tell which.

## In Lean

```lean
inductive Or (a b : Prop) where
  | inl (h : a) : Or a b
  | inr (h : b) : Or a b
```

When you do `cases h` on `h : P \/ Q`, the branches are named after
the constructors:

```lean
cases h with
| inl hp => ...   -- h was built by Or.inl, so hp : P
| inr hq => ...   -- h was built by Or.inr, so hq : Q
```

## Why Not left/right?

The **tactics** `left` and `right` exist for *constructing* an `Or`:

```lean
left   -- applies Or.inl
right  -- applies Or.inr
```

But the **branches** of `cases` are named after the **constructors**
of the inductive type. The constructor is `Or.inl`, so the branch is
`inl`. This is consistent: `cases` on `Nat` gives `zero`/`succ`,
on `Bool` gives `true`/`false`, on `Or` gives `inl`/`inr`.

## The Same Pattern Everywhere

The sum type for data (not propositions) is `Sum`:

```lean
inductive Sum (a b : Type) where
  | inl (val : a) : Sum a b
  | inr (val : b) : Sum a b
```

Same names. Same origin. Coq, Agda, Idris all use `inl`/`inr` or
close variants.

## References

- Saunders Mac Lane, "Categories for the Working Mathematician,"
  Springer, 1971 (chapter on coproducts).
- Per Martin-Lof, "Intuitionistic Type Theory," Bibliopolis, 1984
  (disjoint sum type).

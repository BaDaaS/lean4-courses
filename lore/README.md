# Lore

Behind-the-scenes stories, etymologies, and deep explanations about
Lean 4, type theory, and proof assistants.

Each file is a self-contained story. Read them in any order.

## Etymology and Naming

- [Why "tactic"?](why-tactic.md) - From Milner's LCF (1972) military
  metaphor
- [Why inl/inr?](why-inl-inr.md) - Injection left/right from category
  theory coproduits
- [Why "modus ponens" is just function application](why-modus-ponens.md) -
  The Curry-Howard view of classical logic rules

## Under the Hood

- [What intro/exact/apply actually build](what-tactics-build.md) -
  Every tactic is a term construction step
- [What omega does](what-omega-does.md) - The full pipeline of the
  Omega test
- [def vs theorem vs example](def-vs-theorem.md) - What the kernel
  sees for each declaration keyword
- [What simp does](what-simp-does.md) - The term rewriting engine
- [What the kernel checks](what-the-kernel-checks.md) - The trusted
  core of Lean

## History

- [The Curry-Howard correspondence](curry-howard.md) - How we
  discovered that proofs are programs
- [From LCF to Lean](lcf-to-lean.md) - The family tree of proof
  assistants

# def vs theorem vs example

Lean has several declaration keywords. They look similar but the
kernel and compiler treat them very differently.

## The Core Distinction

A `def` is compiled into executable code. A `theorem` is erased.

```lean
def double (n : Nat) : Nat := 2 * n
#eval double 5  -- 10 (runs compiled code)

theorem two_eq : 1 + 1 = 2 := rfl
-- #eval two_eq  -- ERROR: theorem body was erased
```

Why erase proofs? Because of **proof irrelevance**: in `Prop`, all
proofs of the same statement are definitionally equal. The compiled
program never needs to inspect a proof at runtime.

## All Declaration Keywords

| Keyword | Named? | Compiled? | Reducible? | Erased? |
|---------|--------|-----------|------------|---------|
| `def` | yes | yes | yes | no |
| `abbrev` | yes | yes | always | no |
| `theorem` | yes | no | no (opaque) | yes |
| `lemma` | yes | no | no (opaque) | yes |
| `example` | no | yes* | n/a | discarded |
| `opaque` | yes | depends | never | no |
| `noncomputable def` | yes | no | yes | no |
| `axiom` | yes | no | n/a (no body) | yes |

## The Reducibility Hierarchy

```
abbrev  (@[reducible])    -- elaborator + simp always unfold
   |
  def   (default)         -- unfolded when needed
   |
  def   (@[irreducible])  -- elaborator won't unfold
   |
opaque                    -- kernel won't unfold
   |
theorem                   -- kernel won't unfold + body erased
```

## What the Kernel Sees

The kernel stores declarations as one of five variants:

- `axiomDecl`: no body, trusted on faith
- `defnDecl`: has a body, compiled, reducible
- `thmDecl`: has a body (for verification), then erased
- `opaqueDecl`: has a body, but kernel forbidden from unfolding it
- `inductDecl`: generates constructors and recursors

## Lean's Three Axioms

`axiom` postulates a term without proof. Lean itself has exactly
three built-in axioms:

1. `propext : (a <-> b) -> a = b` (propositional extensionality)
2. `Quot.sound : r a b -> Quot.mk r a = Quot.mk r b` (quotient
   soundness)
3. `Classical.choice : Nonempty a -> a` (axiom of choice)

Check what axioms any definition uses with `#print axioms myDef`.

## References

- Discussion at https://proofassistants.stackexchange.com/questions/1575
- Benjamin Werner, "On the Strength of Proof-Irrelevant Type
  Theories," Logical Methods in Computer Science, 2008.

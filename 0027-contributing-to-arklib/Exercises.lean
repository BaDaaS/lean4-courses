/-
# 0027 - Contributing to ArkLib Exercises

Cryptographic foundations: hash functions, commitments, polynomials,
and Schwartz-Zippel. All exercises use basic Lean with no Mathlib dependency.
-/

-- Exercise 1: Define a HashFunction structure.
-- A hash function maps values from a Domain type to a Range type.
structure HashFunction (Domain : Type) (Range : Type) where
  hash : Domain -> Range

-- Exercise 2: Define collision resistance as a Prop.
-- A hash function is collision resistant if no two distinct inputs
-- map to the same output.
def IsCollisionResistant {Domain : Type} {Range : Type}
    (hf : HashFunction Domain Range) : Prop :=
  sorry

-- Exercise 3: Define a CommitmentScheme structure.
-- A commitment scheme has:
--   - a Message type, a Randomness type, a Commitment type, an Opening type
--   - a commit function: message -> randomness -> commitment
--   - an open/verify function: message -> randomness -> commitment -> Prop
structure CommitmentScheme
    (Message : Type) (Randomness : Type)
    (Commitment : Type) where
  commit : Message -> Randomness -> Commitment
  verify : Message -> Randomness -> Commitment -> Prop

-- Exercise 4: Define the binding property for a commitment scheme.
-- Binding means: if commit(m1, r1) = commit(m2, r2) then m1 = m2.
-- (This is a strong/perfect binding definition.)
def IsBinding {Message : Type} {Randomness : Type}
    {Commitment : Type}
    (cs : CommitmentScheme Message Randomness Commitment) : Prop :=
  sorry

-- Define the hiding property for a commitment scheme.
-- Hiding means: for any two messages, there exist randomness values
-- such that the commitments are equal.
-- (This is a simplified perfect hiding definition.)
def IsHiding {Message : Type} {Randomness : Type}
    {Commitment : Type}
    (cs : CommitmentScheme Message Randomness Commitment) : Prop :=
  sorry

-- Exercise 5: Implement a toy "commitment" using XOR on Nat.
-- commit(m, r) = m ^^^ r (Nat.xor)
-- This is NOT cryptographically secure; it is just for illustration.
def xorCommit : CommitmentScheme Nat Nat Nat where
  commit := sorry
  verify := sorry

-- Prove that xorCommit.verify holds for a valid commitment.
theorem xorCommit_verify_valid (m r : Nat) :
    xorCommit.verify m r (xorCommit.commit m r) := by
  sorry

-- Exercise 6: Define a simple polynomial type over Nat and evaluation.
-- A polynomial is represented as a list of coefficients.
-- [a0, a1, a2, ...] represents a0 + a1*x + a2*x^2 + ...
def Poly := List Nat

-- Evaluate a polynomial at a given point.
def polyEval (p : Poly) (x : Nat) : Nat :=
  sorry

-- Exercise 7: Define polynomial addition (coefficient-wise).
def polyAdd (p q : Poly) : Poly :=
  sorry

-- Prove that evaluation distributes over addition:
-- polyEval (polyAdd p q) x = polyEval p x + polyEval q x
-- Hint: this requires induction on both lists simultaneously.
theorem polyEval_add (p q : Poly) (x : Nat) :
    polyEval (polyAdd p q) x = polyEval p x + polyEval q x := by
  sorry

-- Exercise 8: State the Schwartz-Zippel lemma (type only).
-- For a nonzero polynomial of degree d over a finite set S,
-- the number of roots in S is at most d.
-- We state this abstractly. The proof is left as sorry (it is hard!).

-- Count how many elements of a list satisfy a predicate.
def countSatisfying {alpha : Type} (pred : alpha -> Bool)
    (xs : List alpha) : Nat :=
  sorry

-- State: if p is a nonzero polynomial of degree d, then the number
-- of roots of p in any finite set S is at most d.
-- (We represent "degree" as p.length - 1 and "nonzero" as p not being
-- all zeros.)
def isNonzeroPoly (p : Poly) : Prop :=
  sorry

-- The Schwartz-Zippel statement (proof not required in exercises).
theorem schwartz_zippel_nat (p : Poly) (S : List Nat)
    (hne : isNonzeroPoly p) (hlen : p.length > 0) :
    countSatisfying (fun (x : Nat) => polyEval p x == 0) S
      <= (p.length - 1) * S.length := by
  sorry

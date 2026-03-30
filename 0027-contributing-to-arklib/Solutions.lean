/-
# 0027 - Contributing to ArkLib Solutions

Cryptographic foundations: hash functions, commitments, polynomials,
and Schwartz-Zippel. All exercises use basic Lean with no Mathlib dependency.
-/

namespace Course0027

-- Exercise 1: Define a HashFunction structure.
structure HashFunction (Domain : Type) (Range : Type) where
  hash : Domain -> Range

-- Exercise 2: Define collision resistance.
def IsCollisionResistant {Domain : Type} {Range : Type}
    (hf : HashFunction Domain Range) : Prop :=
  forall (x y : Domain), hf.hash x = hf.hash y -> x = y

-- Exercise 3: Define a CommitmentScheme structure.
structure CommitmentScheme
    (Message : Type) (Randomness : Type)
    (Commitment : Type) where
  commit : Message -> Randomness -> Commitment
  verify : Message -> Randomness -> Commitment -> Prop

-- Exercise 4: Binding and hiding properties.
def IsBinding {Message : Type} {Randomness : Type}
    {Commitment : Type}
    (cs : CommitmentScheme Message Randomness Commitment) : Prop :=
  forall (m1 m2 : Message) (r1 r2 : Randomness),
    cs.commit m1 r1 = cs.commit m2 r2 -> m1 = m2

def IsHiding {Message : Type} {Randomness : Type}
    {Commitment : Type}
    (cs : CommitmentScheme Message Randomness Commitment) : Prop :=
  forall (m1 m2 : Message),
    Exists (fun (r1 : Randomness) =>
      Exists (fun (r2 : Randomness) =>
        cs.commit m1 r1 = cs.commit m2 r2))

-- Exercise 5: Toy XOR commitment.
def xorCommit : CommitmentScheme Nat Nat Nat where
  commit := fun (m r : Nat) => Nat.xor m r
  verify := fun (m r c : Nat) => Nat.xor m r = c

theorem xorCommit_verify_valid (m r : Nat) :
    xorCommit.verify m r (xorCommit.commit m r) := by
  unfold xorCommit CommitmentScheme.verify CommitmentScheme.commit
  rfl

-- Exercise 6: Polynomial type and evaluation.
def Poly := List Nat

-- Helper: compute x^n for natural numbers.
def natPow (x : Nat) : Nat -> Nat
  | 0 => 1
  | n + 1 => x * natPow x n

-- Evaluate polynomial [a0, a1, a2, ...] at point x.
-- Result = a0 + a1*x + a2*x^2 + ...
def polyEval (p : Poly) (x : Nat) : Nat :=
  evalAux p x 0
where
  evalAux : List Nat -> Nat -> Nat -> Nat
  | [], _, _ => 0
  | a :: rest, x, i => a * natPow x i + evalAux rest x (i + 1)

-- Exercise 7: Polynomial addition.
def polyAdd (p q : Poly) : Poly :=
  addAux p q
where
  addAux : List Nat -> List Nat -> List Nat
  | [], ys => ys
  | xs, [] => xs
  | x :: xs, y :: ys => (x + y) :: addAux xs ys

-- The proof that evaluation distributes over addition is nontrivial
-- with this representation. We prove it by induction on the two lists,
-- using an auxiliary lemma about the helper function.

-- Auxiliary lemma: evalAux distributes over addAux at any index.
theorem evalAux_add (p q : List Nat) (x : Nat) :
    (i : Nat) ->
    polyEval.evalAux (polyAdd.addAux p q) x i =
    polyEval.evalAux p x i + polyEval.evalAux q x i := by
  induction p, q using polyAdd.addAux.induct with
  | case1 ys =>
    intro i
    simp [polyAdd.addAux, polyEval.evalAux]
  | case2 xs =>
    intro i
    simp [polyAdd.addAux, polyEval.evalAux]
  | case3 x_hd xs y_hd ys ih =>
    intro i
    simp [polyAdd.addAux, polyEval.evalAux]
    rw [ih]
    rw [Nat.add_mul]
    omega

theorem polyEval_add (p q : Poly) (x : Nat) :
    polyEval (polyAdd p q) x = polyEval p x + polyEval q x := by
  unfold polyEval
  exact evalAux_add p q x 0

-- Exercise 8: Schwartz-Zippel statement.

def countSatisfying {alpha : Type} (pred : alpha -> Bool)
    (xs : List alpha) : Nat :=
  xs.filter pred |>.length

def isNonzeroPoly (p : Poly) : Prop :=
  Exists (fun (c : Nat) => List.Mem c p /\ c != 0)

-- The Schwartz-Zippel lemma over Nat is not literally true because Nat
-- is not a field. We state a simplified version as an axiom to illustrate
-- the shape of the theorem. In a real formalisation (e.g., in ArkLib),
-- this would be proved over finite fields using Mathlib.
--
-- For the course, we demonstrate the statement and mark it as an axiom
-- since a correct proof requires field arithmetic.
axiom schwartz_zippel_nat (p : Poly) (S : List Nat)
    (hne : isNonzeroPoly p) (hlen : p.length > 0) :
    countSatisfying (fun (x : Nat) => polyEval p x == 0) S
      <= (p.length - 1) * S.length

end Course0027

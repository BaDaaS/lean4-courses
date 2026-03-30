/-
# 0025 - Contributing to Mathlib Exercises

These exercises practice defining algebraic structures and proving
their properties, following Mathlib naming and style conventions.

In Mathlib, algebraic hierarchy is built with type classes:
  Semigroup -> Monoid -> Group
  Semigroup -> Monoid -> CommMonoid

Naming conventions:
  - operation_property: mul_assoc, mul_comm, add_assoc
  - identity_operation: one_mul, mul_one, zero_add, add_zero
  - operation_inverse: mul_inv_cancel, add_neg_cancel
-/

universe u

-- Exercise 1: Define a Semigroup typeclass with an associative
-- binary operation called `mul`.
-- Then prove that Nat (under addition) is a Semigroup.
class MySemigroup (S : Type u) where
  mul : S -> S -> S
  mul_assoc : forall (a b c : S),
    mul (mul a b) c = mul a (mul b c)

instance : MySemigroup Nat where
  mul := sorry
  mul_assoc := sorry

-- Exercise 2: Define a Monoid extending Semigroup with an identity
-- element `one` and proofs that one_mul and mul_one hold.
-- Prove instances for Nat (under addition with identity 0)
-- and List (under append with identity []).
class MyMonoid (M : Type u) extends MySemigroup M where
  one : M
  one_mul : forall (a : M), mul one a = a
  mul_one : forall (a : M), mul a one = a

instance : MyMonoid Nat where
  mul := sorry
  mul_assoc := sorry
  one := sorry
  one_mul := sorry
  mul_one := sorry

instance {alpha : Type u} : MyMonoid (List alpha) where
  mul := sorry
  mul_assoc := sorry
  one := sorry
  one_mul := sorry
  mul_one := sorry

-- Exercise 3: Define a Group extending Monoid with an inverse
-- operation and proofs of mul_inv_cancel and inv_mul_cancel.
-- Prove Int (under addition) is a Group.
-- Then prove left cancellation: a * b = a * c -> b = c.
-- Hint: multiply both sides on the left by inv a, then use
-- associativity and inv_mul_cancel.
class MyGroup (G : Type u) extends MyMonoid G where
  inv : G -> G
  mul_inv_cancel : forall (a : G), mul a (inv a) = one
  inv_mul_cancel : forall (a : G), mul (inv a) a = one

instance : MyGroup Int where
  mul := sorry
  mul_assoc := sorry
  one := sorry
  one_mul := sorry
  mul_one := sorry
  inv := sorry
  mul_inv_cancel := sorry
  inv_mul_cancel := sorry

theorem left_cancel {G : Type u} [MyGroup G]
    (a b c : G)
    (h : MySemigroup.mul a b = MySemigroup.mul a c) :
    b = c := by
  sorry

-- Exercise 4: Prove the identity element is unique.
-- If e is any element such that e * a = a for all a,
-- then e must equal the monoid identity `one`.
-- Hint: specialize to a particular value of a.
theorem one_unique {M : Type u} [MyMonoid M]
    (e : M)
    (h : forall (a : M), MySemigroup.mul e a = a) :
    e = MyMonoid.one := by
  sorry

-- Exercise 5: Define a CommMonoid (commutative monoid) extending
-- Monoid with a commutativity proof. Prove Nat is one.
class MyCommMonoid (M : Type u) extends MyMonoid M where
  mul_comm : forall (a b : M), mul a b = mul b a

instance : MyCommMonoid Nat where
  mul := sorry
  mul_assoc := sorry
  one := sorry
  one_mul := sorry
  mul_one := sorry
  mul_comm := sorry

-- Exercise 6: Prove that in a CommMonoid,
-- (a * b) * c = (c * b) * a.
-- Hint: use mul_assoc to reassociate, then mul_comm to swap.
theorem mul_right_comm {M : Type u} [MyCommMonoid M]
    (a b c : M) :
    MySemigroup.mul (MySemigroup.mul a b) c =
    MySemigroup.mul (MySemigroup.mul c b) a := by
  sorry

-- Exercise 7: Following Mathlib naming conventions, provide
-- "wrapper" theorems that expose the class fields as standalone
-- theorems with standard names. This is how Mathlib makes
-- typeclass fields accessible.
-- Fill in the proofs (they should be one-liners).

theorem MySemigroup.mul_assoc' {S : Type u} [MySemigroup S]
    (a b c : S) :
    MySemigroup.mul (MySemigroup.mul a b) c =
    MySemigroup.mul a (MySemigroup.mul b c) := by
  sorry

theorem MyMonoid.one_mul' {M : Type u} [MyMonoid M] (a : M) :
    MySemigroup.mul MyMonoid.one a = a := by
  sorry

theorem MyMonoid.mul_one' {M : Type u} [MyMonoid M] (a : M) :
    MySemigroup.mul a MyMonoid.one = a := by
  sorry

theorem MyCommMonoid.mul_comm' {M : Type u} [MyCommMonoid M]
    (a b : M) :
    MySemigroup.mul a b = MySemigroup.mul b a := by
  sorry

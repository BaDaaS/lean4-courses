/-
# 0013 - Algebraic Structures Exercises
-/

-- Exercise 1: Define a Semigroup typeclass (associative binary operation)
class MySemigroup (S : Type) where
  op : S -> S -> S
  op_assoc : forall a b c : S, op (op a b) c = op a (op b c)

-- Exercise 2: Provide a Semigroup instance for Nat (under addition)
instance : MySemigroup Nat where
  op := sorry
  op_assoc := sorry

-- Exercise 3: Define a Monoid extending Semigroup
class MyMonoid' (M : Type) extends MySemigroup M where
  e : M
  e_op : forall a : M, op e a = a
  op_e : forall a : M, op a e = a

-- Exercise 4: Provide a Monoid instance for Nat (under addition)
instance : MyMonoid' Nat where
  op := sorry
  op_assoc := sorry
  e := sorry
  e_op := sorry
  op_e := sorry

-- Exercise 5: Write a generic "power" function for any Monoid
-- Compute a^n = a * a * ... * a (n times)
def myPow [MyMonoid' M] (a : M) (n : Nat) : M := sorry

-- Exercise 6: Provide a Monoid instance for List (under append)
instance : MyMonoid' (List alpha) where
  op := sorry
  op_assoc := sorry
  e := sorry
  e_op := sorry
  op_e := sorry

-- Exercise 7: Write a generic fold using Monoid
def mconcat [MyMonoid' M] (xs : List M) : M := sorry

-- Exercise 8: Define a Group typeclass
class MyGroup' (G : Type) extends MyMonoid' G where
  inv : G -> G
  op_inv : forall a : G, op a (inv a) = e

-- Exercise 9: Provide a Group instance for Int (under addition)
instance : MyGroup' Int where
  op := sorry
  op_assoc := sorry
  e := sorry
  e_op := sorry
  op_e := sorry
  inv := sorry
  op_inv := sorry

-- Exercise 10 (medium): Prove that the identity element of a monoid
-- is unique. If e' also satisfies the identity laws, then e' = e.
-- Use your MyMonoid' from Exercise 3.
theorem identity_unique [MyMonoid' M]
    (e' : M) (h_left : forall a : M, MySemigroup.op e' a = a)
    (h_right : forall a : M, MySemigroup.op a e' = a) :
    e' = MyMonoid'.e := sorry

-- Exercise 11 (hard): Define a structure for a monoid homomorphism
-- and prove that the composition of two homomorphisms is a
-- homomorphism.
structure MyMonoidHom (M : Type) (N : Type)
    [MyMonoid' M] [MyMonoid' N] where
  f : M -> N
  map_e : f MyMonoid'.e = MyMonoid'.e
  map_op : forall (a b : M),
    f (MySemigroup.op a b) = MySemigroup.op (f a) (f b)

def compMonoidHom [MyMonoid' M] [MyMonoid' N] [MyMonoid' P]
    (g : MyMonoidHom N P) (h : MyMonoidHom M N) :
    MyMonoidHom M P := sorry

-- Exercise 12 (hard): Prove the anti-homomorphism property of
-- inverse in a group: (a * b)^(-1) = b^(-1) * a^(-1).
-- You will need to add an inv_op axiom to your group or prove it
-- from existing axioms. For this exercise, assume a stronger
-- group with left inverse as well.
class MyGroup2 (G : Type) extends MyMonoid' G where
  inv : G -> G
  op_inv : forall (a : G), op a (inv a) = e
  inv_op : forall (a : G), op (inv a) a = e

theorem inv_anti_hom [MyGroup2 G] (a b : G) :
    MyGroup2.inv (MySemigroup.op a b) =
    MySemigroup.op (MyGroup2.inv b) (MyGroup2.inv a) := sorry

-- Exercise 13 (challenge): Define an equivalence relation on a
-- type and show it satisfies reflexivity, symmetry, and
-- transitivity.
structure MyEquivRel (alpha : Type) where
  rel : alpha -> alpha -> Prop
  refl : forall (a : alpha), rel a a
  symm : forall (a b : alpha), rel a b -> rel b a
  trans : forall (a b c : alpha),
    rel a b -> rel b c -> rel a c

-- Define the trivial equivalence relation (everything is related
-- to everything) and prove it satisfies the laws.
def trivialEquivRel (alpha : Type) : MyEquivRel alpha := sorry

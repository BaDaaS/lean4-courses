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

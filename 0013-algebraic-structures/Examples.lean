/-
# 0013 - Algebraic Structures Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0013Examples

-- #anchor: monoid
class MyMonoid (M : Type) where
  one : M
  mul : M -> M -> M
  mul_assoc : forall a b c : M, mul (mul a b) c = mul a (mul b c)
  one_mul : forall a : M, mul one a = a
  mul_one : forall a : M, mul a one = a
-- #end

-- #anchor: group
class MyGroup (G : Type) extends MyMonoid G where
  inv : G -> G
  mul_inv : forall a : G, mul a (inv a) = one
-- #end

-- #anchor: ring
-- Simplified
class MyRing (R : Type) where
  zero : R
  one : R
  add : R -> R -> R
  mul : R -> R -> R
  neg : R -> R
  -- plus axioms: add_comm, add_assoc, mul_assoc, distrib, etc.
-- #end

end Course0013Examples

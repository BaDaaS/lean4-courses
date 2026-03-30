/-
# 0025 - Contributing to Mathlib Solutions

These exercises practice defining algebraic structures and proving
properties following Mathlib conventions.
-/

namespace Course0025

universe u

-- Exercise 1: Define a Semigroup class and prove Nat is one
class MySemigroup (S : Type u) where
  mul : S -> S -> S
  mul_assoc : forall (a b c : S), mul (mul a b) c = mul a (mul b c)

instance : MySemigroup Nat where
  mul := Nat.add
  mul_assoc := Nat.add_assoc

-- Exercise 2: Define a Monoid class extending Semigroup,
-- prove Nat and List instances
class MyMonoid (M : Type u) extends MySemigroup M where
  one : M
  one_mul : forall (a : M), mul one a = a
  mul_one : forall (a : M), mul a one = a

instance : MyMonoid Nat where
  mul := Nat.add
  mul_assoc := Nat.add_assoc
  one := 0
  one_mul := Nat.zero_add
  mul_one := fun _ => rfl

instance {alpha : Type u} : MyMonoid (List alpha) where
  mul := List.append
  mul_assoc := List.append_assoc
  one := []
  one_mul := List.nil_append
  mul_one := List.append_nil

-- Exercise 3: Define a Group class and prove left_cancel.
-- We include both mul_inv_cancel and inv_mul_cancel as axioms
-- (as Mathlib does in practice).
class MyGroup (G : Type u) extends MyMonoid G where
  inv : G -> G
  mul_inv_cancel : forall (a : G), mul a (inv a) = one
  inv_mul_cancel : forall (a : G), mul (inv a) a = one

instance : MyGroup Int where
  mul := Int.add
  mul_assoc := Int.add_assoc
  one := 0
  one_mul := Int.zero_add
  mul_one := Int.add_zero
  inv := Int.neg
  mul_inv_cancel := Int.add_right_neg
  inv_mul_cancel := Int.add_left_neg

theorem left_cancel {G : Type u} [MyGroup G]
    (a b c : G)
    (h : MySemigroup.mul a b = MySemigroup.mul a c) :
    b = c := by
  have h1 : MySemigroup.mul (MyGroup.inv a)
      (MySemigroup.mul a b) =
      MySemigroup.mul (MyGroup.inv a)
      (MySemigroup.mul a c) := by
    rw [h]
  rw [<- MySemigroup.mul_assoc, <- MySemigroup.mul_assoc] at h1
  rw [MyGroup.inv_mul_cancel] at h1
  rw [MyMonoid.one_mul, MyMonoid.one_mul] at h1
  exact h1

-- Exercise 4: Prove the identity element is unique
theorem one_unique {M : Type u} [MyMonoid M]
    (e : M) (h : forall (a : M), MySemigroup.mul e a = a) :
    e = MyMonoid.one := by
  have := h MyMonoid.one
  rw [MyMonoid.mul_one] at this
  exact this

-- Exercise 5: Define CommMonoid, prove Nat is one
class MyCommMonoid (M : Type u) extends MyMonoid M where
  mul_comm : forall (a b : M), mul a b = mul b a

instance : MyCommMonoid Nat where
  mul := Nat.add
  mul_assoc := Nat.add_assoc
  one := 0
  one_mul := Nat.zero_add
  mul_one := fun _ => rfl
  mul_comm := Nat.add_comm

-- Exercise 6: Prove that in a CommMonoid, a * b * c = c * b * a
theorem mul_right_comm {M : Type u} [MyCommMonoid M]
    (a b c : M) :
    MySemigroup.mul (MySemigroup.mul a b) c =
    MySemigroup.mul (MySemigroup.mul c b) a := by
  rw [MySemigroup.mul_assoc]
  rw [MyCommMonoid.mul_comm b c]
  rw [MyCommMonoid.mul_comm a (MySemigroup.mul c b)]

-- Exercise 7: Following Mathlib naming conventions.
-- In Mathlib, theorem names describe the statement systematically:
--   operation_property: mul_assoc, mul_comm
--   identity_operation: one_mul, mul_one
--   operation_inverse: mul_inv_cancel
-- Prove these named lemmas as wrappers for our structures.

theorem MySemigroup.mul_assoc' {S : Type u} [MySemigroup S]
    (a b c : S) :
    MySemigroup.mul (MySemigroup.mul a b) c =
    MySemigroup.mul a (MySemigroup.mul b c) :=
  MySemigroup.mul_assoc a b c

theorem MyMonoid.one_mul' {M : Type u} [MyMonoid M] (a : M) :
    MySemigroup.mul MyMonoid.one a = a :=
  MyMonoid.one_mul a

theorem MyMonoid.mul_one' {M : Type u} [MyMonoid M] (a : M) :
    MySemigroup.mul a MyMonoid.one = a :=
  MyMonoid.mul_one a

theorem MyCommMonoid.mul_comm' {M : Type u} [MyCommMonoid M]
    (a b : M) :
    MySemigroup.mul a b = MySemigroup.mul b a :=
  MyCommMonoid.mul_comm a b

end Course0025

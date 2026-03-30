/-
# 0013 - Algebraic Structures Solutions
-/

namespace Course0013

universe u

-- Exercise 1
class MySemigroup (S : Type u) where
  op : S -> S -> S
  op_assoc : forall (a b c : S), op (op a b) c = op a (op b c)

-- Exercise 2
instance : MySemigroup Nat where
  op := Nat.add
  op_assoc := Nat.add_assoc

-- Exercise 3
class MyMonoid' (M : Type u) extends MySemigroup M where
  e : M
  e_op : forall (a : M), op e a = a
  op_e : forall (a : M), op a e = a

-- Exercise 4
instance : MyMonoid' Nat where
  op := Nat.add
  op_assoc := Nat.add_assoc
  e := 0
  e_op := Nat.zero_add
  op_e := fun _ => rfl

-- Exercise 5
def myPow {M : Type u} [MyMonoid' M] (a : M) (n : Nat) : M :=
  match n with
  | 0 => MyMonoid'.e
  | n + 1 => MySemigroup.op a (myPow a n)

-- Exercise 6
instance {alpha : Type u} : MyMonoid' (List alpha) where
  op := List.append
  op_assoc := List.append_assoc
  e := []
  e_op := List.nil_append
  op_e := List.append_nil

-- Exercise 7
def mconcat {M : Type u} [MyMonoid' M] (xs : List M) : M :=
  xs.foldl MySemigroup.op MyMonoid'.e

-- Exercise 8
class MyGroup' (G : Type u) extends MyMonoid' G where
  inv : G -> G
  op_inv : forall (a : G), op a (inv a) = e

-- Exercise 9
instance : MyGroup' Int where
  op := Int.add
  op_assoc := Int.add_assoc
  e := 0
  e_op := Int.zero_add
  op_e := Int.add_zero
  inv := Int.neg
  op_inv := Int.add_neg_cancel

end Course0013

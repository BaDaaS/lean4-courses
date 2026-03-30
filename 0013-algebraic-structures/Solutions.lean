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
  op_inv := Int.add_right_neg

-- Exercise 10 (medium): Identity is unique
theorem identity_unique {M : Type u} [MyMonoid' M]
    (e' : M) (h_left : forall (a : M), MySemigroup.op e' a = a)
    (_h_right : forall (a : M), MySemigroup.op a e' = a) :
    e' = MyMonoid'.e := by
  have h := h_left MyMonoid'.e
  rw [MyMonoid'.op_e] at h
  exact h

-- Exercise 11 (hard): Monoid homomorphism and composition
structure MyMonoidHom (M : Type u) (N : Type u)
    [MyMonoid' M] [MyMonoid' N] where
  f : M -> N
  map_e : f MyMonoid'.e = MyMonoid'.e
  map_op : forall (a b : M),
    f (MySemigroup.op a b) = MySemigroup.op (f a) (f b)

def compMonoidHom {M : Type u} {N : Type u} {P : Type u}
    [MyMonoid' M] [MyMonoid' N] [MyMonoid' P]
    (g : MyMonoidHom N P) (h : MyMonoidHom M N) :
    MyMonoidHom M P where
  f := fun x => g.f (h.f x)
  map_e := by rw [h.map_e, g.map_e]
  map_op := by
    intro a b
    rw [h.map_op, g.map_op]

-- Exercise 12 (hard): Anti-homomorphism of inverse
class MyGroup2 (G : Type u) extends MyMonoid' G where
  inv : G -> G
  op_inv : forall (a : G), op a (inv a) = e
  inv_op : forall (a : G), op (inv a) a = e

-- Helper: if op a x = e then x = inv a
private theorem inv_unique {G : Type u} [MyGroup2 G]
    (a x : G)
    (h : MySemigroup.op a x = MyMonoid'.e) :
    x = MyGroup2.inv a := by
  -- Apply inv(a) on the left of both sides
  have step1 : MySemigroup.op (MyGroup2.inv a)
      (MySemigroup.op a x) =
    MySemigroup.op (MyGroup2.inv a) MyMonoid'.e :=
    congrArg (MySemigroup.op (MyGroup2.inv a)) h
  rw [<- MySemigroup.op_assoc] at step1
  rw [MyGroup2.inv_op] at step1
  rw [MyMonoid'.e_op] at step1
  rw [MyMonoid'.op_e] at step1
  exact step1

theorem inv_anti_hom {G : Type u} [MyGroup2 G] (a b : G) :
    MyGroup2.inv (MySemigroup.op a b) =
    MySemigroup.op (MyGroup2.inv b) (MyGroup2.inv a) := by
  -- Show (a*b) * (b^-1 * a^-1) = e, then use uniqueness
  apply Eq.symm
  apply inv_unique
  rw [MySemigroup.op_assoc a b _]
  rw [<- MySemigroup.op_assoc b
    (MyGroup2.inv b) (MyGroup2.inv a)]
  rw [MyGroup2.op_inv b]
  rw [MyMonoid'.e_op]
  rw [MyGroup2.op_inv a]

-- Exercise 13 (challenge): Equivalence relation
structure MyEquivRel (alpha : Type u) where
  rel : alpha -> alpha -> Prop
  refl : forall (a : alpha), rel a a
  symm : forall (a b : alpha), rel a b -> rel b a
  trans : forall (a b c : alpha),
    rel a b -> rel b c -> rel a c

def trivialEquivRel (alpha : Type u) : MyEquivRel alpha where
  rel := fun _ _ => True
  refl := fun _ => trivial
  symm := fun _ _ _ => trivial
  trans := fun _ _ _ _ _ => trivial

end Course0013

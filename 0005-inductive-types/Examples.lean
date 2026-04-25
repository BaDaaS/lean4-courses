/-
# 0005 - Inductive Types Examples

Runnable examples from the README, anchored for documentation.
-/

namespace Course0005Examples

-- #anchor: polymorphic_id
def myId {alpha : Type} (x : alpha) : alpha := x
-- #end

-- #anchor: universe_polymorphic_id
universe u
def myId' {alpha : Type u} (x : alpha) : alpha := x
-- #end

-- #anchor: weekday_enum
inductive Weekday where
  | monday | tuesday | wednesday | thursday
  | friday | saturday | sunday
-- #end

-- #anchor: shape_with_data
inductive Shape where
  | circle (radius : Float)
  | rectangle (width : Float) (height : Float)
  | triangle (base : Float) (height : Float)
-- #end

-- #anchor: mynat_recursive
inductive MyNat where
  | zero : MyNat
  | succ (n : MyNat) : MyNat
-- #end

-- #anchor: nat_encoding_comment
-- Nat is defined as:
-- inductive Nat where
--   | zero : Nat
--   | succ (n : Nat) : Nat

-- 3 is sugar for: Nat.succ (Nat.succ (Nat.succ Nat.zero))
-- #end

-- #anchor: pattern_matching_weekday_shape
def weekdayToString : Weekday -> String
  | .monday    => "Monday"
  | .tuesday   => "Tuesday"
  | .wednesday => "Wednesday"
  | .thursday  => "Thursday"
  | .friday    => "Friday"
  | .saturday  => "Saturday"
  | .sunday    => "Sunday"

def area : Shape -> Float
  | .circle r       => 3.14159265358979 * r * r
  | .rectangle w h  => w * h
  | .triangle b h   => 0.5 * b * h
-- #end

-- #anchor: myadd_recursive
def myAdd : MyNat -> MyNat -> MyNat
  | .zero,   m => m
  | .succ n, m => .succ (myAdd n m)
-- #end

-- #anchor: mylist_parameterized
inductive MyList (alpha : Type) where
  | nil : MyList alpha
  | cons (head : alpha) (tail : MyList alpha) : MyList alpha

def myLength {alpha : Type} : MyList alpha -> Nat
  | .nil => 0
  | .cons _ tail => 1 + myLength tail
-- #end

-- #anchor: maybe_type
inductive Maybe (alpha : Type) where
  | nothing : Maybe alpha
  | just    : alpha -> Maybe alpha
-- #end

-- #anchor: maybe_introduction
-- Introducing a Maybe value
#check (Maybe.just 42)    -- : Maybe Nat
#check (@Maybe.nothing Nat)  -- : Maybe Nat
-- #end

-- #anchor: maybe_elimination
def maybeMap {alpha beta : Type}
    (f : alpha -> beta) (x : Maybe alpha) : Maybe beta :=
  match x with
  | .nothing => .nothing
  | .just a  => .just (f a)
-- #end

-- #anchor: myoption_adt
-- Like Haskell's: data Maybe a = Nothing | Just a
inductive MyOption (alpha : Type) where
  | none : MyOption alpha
  | some (val : alpha) : MyOption alpha
-- #end

-- #anchor: typed_expr_indexed
inductive Ty where
  | nat  : Ty
  | bool : Ty

inductive TypedExpr : Ty -> Type where
  | litNat  : Nat -> TypedExpr .nat
  | litBool : Bool -> TypedExpr .bool
  | addExpr : TypedExpr .nat -> TypedExpr .nat -> TypedExpr .nat
  | eqExpr  : TypedExpr .nat -> TypedExpr .nat -> TypedExpr .bool
-- #end

-- #anchor: vector_indexed
inductive Vector (alpha : Type) : Nat -> Type where
  | nil  : Vector alpha 0
  | cons : {n : Nat} -> alpha -> Vector alpha n -> Vector alpha (n + 1)
-- #end

end Course0005Examples

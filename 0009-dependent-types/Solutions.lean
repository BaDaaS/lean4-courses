/-
# 0009 - Dependent Types Solutions
-/

namespace Course0009

universe u v

inductive Vec (alpha : Type u) : Nat -> Type u where
  | nil : Vec alpha 0
  | cons {n : Nat} (head : alpha) (tail : Vec alpha n) :
      Vec alpha (n + 1)

-- Exercise 2
def Vec.head {alpha : Type u} {n : Nat} :
    Vec alpha (n + 1) -> alpha
  | .cons h _ => h

-- Exercise 3
def Vec.tail {alpha : Type u} {n : Nat} :
    Vec alpha (n + 1) -> Vec alpha n
  | .cons _ t => t

-- Exercise 4
def Vec.map {alpha : Type u} {beta : Type v} {n : Nat}
    (f : alpha -> beta) : Vec alpha n -> Vec beta n
  | .nil => .nil
  | .cons h t => .cons (f h) (Vec.map f t)

-- Exercise 5
def Vec.append {alpha : Type u} {n m : Nat} :
    Vec alpha n -> Vec alpha m -> Vec alpha (n + m)
  | .nil, ys => ys
  | .cons x xs, ys => .cons x (Vec.append xs ys)

-- Exercise 6
def safeDiv (a : Nat) (b : Nat) (_ : b > 0) : Nat :=
  a / b

-- Exercise 7
def EvenNat := { n : Nat // n % 2 = 0 }

def zero_even : EvenNat := <0, rfl>
def four_even : EvenNat := <4, rfl>

-- Exercise 8
def Vec.replicate {alpha : Type u} (n : Nat) (x : alpha) :
    Vec alpha n :=
  match n with
  | 0 => .nil
  | n + 1 => .cons x (Vec.replicate n x)

-- Exercise 9
def Vec.zip {alpha : Type u} {beta : Type v} {n : Nat} :
    Vec alpha n -> Vec beta n -> Vec (alpha x beta) n
  | .nil, .nil => .nil
  | .cons a as, .cons b bs => .cons (a, b) (Vec.zip as bs)

end Course0009

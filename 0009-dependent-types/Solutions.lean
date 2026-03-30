/-
# 0009 - Dependent Types Solutions
-/

namespace Course0009

universe u v w

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
def Vec.append {alpha : Type u} {n m : Nat}
    (xs : Vec alpha n) (ys : Vec alpha m) : Vec alpha (n + m) :=
  match n, xs with
  | 0, .nil => by simpa using ys
  | _ + 1, .cons x xs => by
    simp [Nat.succ_add]
    exact .cons x (Vec.append xs ys)

-- Exercise 6
def safeDiv (a : Nat) (b : Nat) (_ : b > 0) : Nat :=
  a / b

-- Exercise 7
def EvenNat := { n : Nat // n % 2 = 0 }

def zero_even : EvenNat := ⟨0, rfl⟩
def four_even : EvenNat := ⟨4, rfl⟩

-- Exercise 8
def Vec.replicate {alpha : Type u} (n : Nat) (x : alpha) :
    Vec alpha n :=
  match n with
  | 0 => .nil
  | n + 1 => .cons x (Vec.replicate n x)

-- Exercise 9
def Vec.zip {alpha : Type u} {beta : Type v} {n : Nat} :
    Vec alpha n -> Vec beta n -> Vec (alpha × beta) n
  | .nil, .nil => .nil
  | .cons a as, .cons b bs => .cons (a, b) (Vec.zip as bs)

-- ============================================================
-- Additional Exercises
-- ============================================================

-- Exercise 10 (medium): NonEmpty list
structure NonEmpty (alpha : Type u) where
  head : alpha
  tail : List alpha

def NonEmpty.toList {alpha : Type u} (ne : NonEmpty alpha) :
    List alpha :=
  ne.head :: ne.tail

def NonEmpty.fromList? {alpha : Type u} (xs : List alpha) :
    Option (NonEmpty alpha) :=
  match xs with
  | [] => none
  | x :: rest => some { head := x, tail := rest }

def NonEmpty.length {alpha : Type u} (ne : NonEmpty alpha) : Nat :=
  1 + ne.tail.length

#eval (NonEmpty.mk 1 [2, 3]).length  -- 3

-- Exercise 11 (hard): Matrix as Vec of Vecs
def Matrix (alpha : Type u) (rows cols : Nat) : Type u :=
  Vec (Vec alpha cols) rows

def Vec.get {alpha : Type u} {n : Nat} :
    Vec alpha n -> Fin n -> alpha
  | .cons x _, { val := 0, isLt := _ } => x
  | .cons _ xs, { val := i + 1, isLt := h } =>
    Vec.get xs { val := i, isLt := Nat.lt_of_succ_lt_succ h }

def Matrix.get {alpha : Type u} {rows cols : Nat}
    (m : Matrix alpha rows cols)
    (i : Fin rows) (j : Fin cols) : alpha :=
  (Vec.get m i).get j

def Vec.tabulate {alpha : Type u} (n : Nat)
    (f : Fin n -> alpha) : Vec alpha n :=
  match n with
  | 0 => .nil
  | n + 1 =>
    .cons (f { val := 0, isLt := Nat.zero_lt_succ n })
      (Vec.tabulate n (fun i =>
        f { val := i.val + 1,
            isLt := Nat.succ_lt_succ i.isLt }))

def Matrix.transpose {alpha : Type u} {rows cols : Nat}
    (m : Matrix alpha rows cols) :
    Matrix alpha cols rows :=
  Vec.tabulate cols (fun j =>
    Vec.tabulate rows (fun i => Matrix.get m i j))

-- Exercise 12 (hard): Vec.reverse via accumulator
-- We use a cast-based approach since n + m = m + n needs a proof.
def Vec.reverseAux {alpha : Type u} {n m : Nat}
    (xs : Vec alpha n) (acc : Vec alpha m) : Vec alpha (n + m) :=
  match n, xs with
  | 0, .nil => by simpa using acc
  | k + 1, .cons x rest => by
    have : k + 1 + m = k + (m + 1) := by omega
    rw [this]
    exact Vec.reverseAux rest (.cons x acc)

def Vec.reverse {alpha : Type u} {n : Nat}
    (v : Vec alpha n) : Vec alpha n := by
  have h : n = n + 0 := by omega
  rw [h]
  exact Vec.reverseAux v .nil

-- Exercise 13 (challenge): Vec.map composed
theorem Vec.map_map {alpha : Type u} {beta : Type v}
    {gamma : Type w} {n : Nat}
    (f : beta -> gamma) (g : alpha -> beta)
    (v : Vec alpha n) :
    Vec.map f (Vec.map g v) = Vec.map (fun x => f (g x)) v := by
  induction v with
  | nil => rfl
  | cons h t ih => simp [Vec.map, ih]

end Course0009

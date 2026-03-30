/-
# 0015 - Automation and Simp Solutions
-/

namespace Course0015

-- Exercise 1
theorem simp_ex1 (xs ys : List Nat) :
    (xs ++ ys).length = xs.length + ys.length := by
  simp

-- Exercise 2
theorem omega_ex1 (n : Nat) (h : n >= 10) : n >= 5 := by
  omega

-- Exercise 3
theorem omega_ex2 (a b : Nat) (h1 : a > b) (h2 : b > 0) :
    a >= 2 := by
  omega

-- Exercise 4
theorem decide_ex1 : 15 % 4 = 3 := by
  decide

-- Exercise 5
theorem simp_ex2 (n : Nat) : n * 1 = n := by
  simp

-- Exercise 6
theorem combo_ex1 (xs : List Nat) :
    (xs ++ []).length = xs.length := by
  simp

-- Exercise 7
def double (n : Nat) : Nat := n + n

@[simp]
theorem double_eq (n : Nat) : double n = n + n := rfl

theorem double_4 : double 4 = 8 := by
  simp

-- Exercise 8
theorem omega_int (a b : Int) (h : a + b > 10) (h2 : a <= 5) :
    b > 5 := by
  omega

-- Exercise 9
theorem combo_ex2 (xs : List Nat) (h : xs.length > 0) :
    (xs ++ [42]).length > 1 := by
  simp; omega

-- Exercise 10
theorem challenge_auto (n m : Nat) (h : n > 0) (h2 : m > 0) :
    n * m > 0 := by
  exact Nat.mul_pos h h2

-- Exercise 11 (medium): Custom simp set
def triple (n : Nat) : Nat := 3 * n

@[simp]
theorem triple_eq (n : Nat) : triple n = 3 * n := rfl

theorem triple_2 : triple 2 = 6 := by
  simp only [triple_eq]

-- Exercise 12 (hard): conv to rewrite inside nested expression
theorem conv_nested (a b : Nat) :
    (a + 0) + (b + 0) = a + b := by
  conv =>
    lhs
    rw [Nat.add_zero, Nat.add_zero]

-- Exercise 13 (hard): Combine simp and omega
theorem combo_multi (xs : List Nat) (n : Nat) :
    (xs ++ [n]).length = xs.length + 1 := by
  simp

-- Exercise 14 (hard): conv targeted rewrite
theorem conv_targeted (a b c : Nat) (h : a = b) :
    a + c = b + c := by
  conv =>
    lhs
    rw [h]

-- Exercise 15 (challenge): Careful tactic sequencing
def myFun (n : Nat) : Nat := n * 2 + 1

theorem challenge_sequencing (a b : Nat)
    (h : a = b + 3) :
    myFun a = myFun b + 6 := by
  unfold myFun
  omega

end Course0015

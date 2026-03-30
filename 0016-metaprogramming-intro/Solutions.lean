/-
# 0016 - Metaprogramming Intro Solutions
-/

-- Exercise 1
macro "the_answer" : term => `(42)
#eval the_answer  -- 42

-- Exercise 2
macro:25 a:term " ==> " b:term : term => `(!$a || $b)
#eval (true ==> false)   -- false
#eval (false ==> false)  -- true

-- Exercise 3
macro "myabs" x:term : term => `(Int.natAbs $x)
#eval myabs (-5 : Int)  -- 5

-- Exercise 4
macro "auto" : tactic => `(tactic| first | rfl | simp | omega)

example : 3 + 0 = 3 := by auto
example (n : Nat) : n + 0 = n := by auto
example (n : Nat) (h : n > 5) : n > 2 := by auto

-- Exercise 5
macro "skip" : tactic => `(tactic| pure ())

-- Exercise 6
infixr:90 " << " => Function.comp

def double (n : Nat) : Nat := n * 2
def inc (n : Nat) : Nat := n + 1

#eval (double << inc) 3  -- 8

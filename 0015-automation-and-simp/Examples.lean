/-
# 0015 - Automation and Simp Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0015Examples

-- #anchor: simp_basics
example (xs : List Nat) : xs ++ [] = xs := by simp
example (n : Nat) : n + 0 = n := by simp
example (n : Nat) : 0 + n = n := by simp
-- #end

-- #anchor: simp_only
example (a b c : Nat) (h : a = b) : a + c = b + c := by
  simp only [h]
-- #end

-- #anchor: adding_simp_lemmas
def double (n : Nat) : Nat := 2 * n

@[simp]
theorem double_def (n : Nat) : double n = 2 * n := rfl

-- Now simp will automatically use this
-- #end

-- #anchor: omega_examples
example (n m : Nat) (h : n < m) : n + 1 <= m := by omega
example (a b : Int) (h1 : a > 0) (h2 : b > 0) : a + b > 0 := by omega
-- #end

-- #anchor: decide_examples
example : 2 + 2 = 4 := by decide
-- #end

-- #anchor: combining_tactics
-- simp then omega for the remainder
example (n : Nat) (h : n > 0) : n - 1 + 1 = n := by
  omega
-- #end

end Course0015Examples

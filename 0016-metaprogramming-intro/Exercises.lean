/-
# 0016 - Metaprogramming Intro Exercises
-/

-- Exercise 1: Define a macro that expands to 42
macro "the_answer" : term => `(42)

-- Verify:
-- #eval the_answer  -- should be 42

-- Exercise 2: Define a macro for boolean "implies" (not short-circuit)
-- a ==> b should mean: !a || b
macro:25 a:term " ==> " b:term : term => `(!$a || $b)

-- #eval (true ==> false)   -- false
-- #eval (false ==> false)  -- true

-- Exercise 3: Define custom notation for absolute value of Int
-- Use: |x| for Int.natAbs x
-- Note: this might conflict with existing syntax, so use a different name
macro "myabs" x:term : term => sorry

-- Exercise 4: Define a macro "auto" that tries rfl, simp, then omega
macro "auto" : tactic => sorry

-- Test it:
-- example : 3 + 0 = 3 := by auto
-- example (n : Nat) : n + 0 = n := by auto
-- example (n : Nat) (h : n > 5) : n > 2 := by auto

-- Exercise 5: Define a do-nothing tactic called "skip"
macro "skip" : tactic => sorry

-- Exercise 6: Define notation for function composition
-- (f << g) x = f (g x)
-- Already exists as Function.comp, but define your own notation
infixr:90 " << " => sorry

-- Exercise 7: Define a command macro that prints a message
-- Usage: #greet "Alice" should output: Hello, Alice!
-- (This is advanced, feel free to skip)

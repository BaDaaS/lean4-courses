/-
# 0030 - Advanced Metaprogramming Exercises
-/

namespace Course0030E

-- Exercise 1: Define a macro `myAssert` that checks a decidable Prop
-- at elaboration time. If the proposition is true, it produces a proof.
-- If false, elaboration fails with an error.
-- Hint: expand to `(by decide : cond)`
macro "myAssert" "(" cond:term ")" : term => sorry

-- Test: #check myAssert (1 + 1 = 2) should succeed
-- Test: myAssert (1 + 1 = 3) should fail

-- Exercise 2: Define a notation for list comprehension-style syntax
-- [| f x | x in xs |] should map f over list xs
-- Hint: expand to List.map (fun x => f) xs
macro "[|" f:term "|" x:ident "in" xs:term "|]" : term => sorry

-- Test: #eval [| x * 2 | x in [1, 2, 3] |] should give [2, 4, 6]

-- Exercise 3: Define custom syntax for a simple conditional
-- pick <expr> ifYes <expr> ifNo <expr>
-- should expand to if-then-else
syntax "pick" term "ifYes" term "ifNo" term : term

-- Fill in the macro_rules:
-- macro_rules
--   | `(pick $cond ifYes $t ifNo $f) => sorry

-- Test: #eval pick (1 < 2) ifYes "yes" ifNo "no"

-- Exercise 4: Write a macro that converts a Color value to a string
inductive Color where
  | red | blue
deriving Repr

-- First define the function:
def colorToString : Color -> String := sorry

-- Then define a macro "colorName" that calls it:
macro "colorName" c:term : term => sorry

-- Test: #eval colorName Color.red should give "red"

-- Exercise 5: Define a DSL for state machines
-- Create a type for transitions and state machines,
-- then define notation and macros to build them.

structure SMTransition where
  src : String
  dst : String
deriving Repr

structure StateMachine where
  states : List String
  transitions : List SMTransition
deriving Repr

-- Define notation for transitions: "A" ~> "B"
-- Hint: use `syntax` and `macro_rules`
-- syntax:50 term " ~> " term : term
-- macro_rules | `($a ~> $b) => sorry

-- Define a macro mkSM to build a StateMachine:
-- mkSM ["A", "B"] [list of transitions]
-- macro "mkSM" "[" ss:term,* "]" "[" ts:term,* "]" : term => sorry

-- Exercise 6: Write a tactic that closes a goal of True
-- Hint: expand to `exact True.intro`
macro "closeTrue" : tactic => sorry

-- Test: example : True := by closeTrue

end Course0030E

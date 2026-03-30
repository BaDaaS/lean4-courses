/-
# 0030 - Advanced Metaprogramming Solutions
-/

namespace Course0030

-- Exercise 1: Define a macro `myAssert` that checks a decidable Prop
-- and produces a proof or fails.
-- We use `decide` to discharge the proof obligation at elaboration time.
macro "myAssert" "(" cond:term ")" : term =>
  `((by decide : $cond))

-- These succeed because the propositions are decidably true:
#check myAssert (1 + 1 = 2)
#check myAssert (10 > 5)

-- Exercise 2: Define a notation for list comprehension-style syntax
-- [| f x | x in xs |] maps f over a list
macro "[|" f:term "|" x:ident "in" xs:term "|]" : term =>
  `(List.map (fun $x => $f) $xs)

#eval [| x * 2 | x in [1, 2, 3, 4] |]  -- [2, 4, 6, 8]
#eval [| x + 10 | x in [5, 10, 15] |]  -- [15, 20, 25]

-- Exercise 3: Define custom syntax for a simple conditional
-- Syntax: pick <expr> ifYes <expr> ifNo <expr>
syntax "pick" term "ifYes" term "ifNo" term : term

macro_rules
  | `(pick $cond ifYes $t ifNo $f) =>
    `(if $cond then $t else $f)

#eval pick (1 < 2) ifYes "yes" ifNo "no"   -- "yes"
#eval pick (1 > 2) ifYes "yes" ifNo "no"   -- "no"

-- Exercise 4: Write a macro that pattern matches on a Color value
-- and returns its name as a string.
inductive Color where
  | red | blue
deriving Repr

def colorToString : Color -> String
  | .red => "red"
  | .blue => "blue"

-- A macro that wraps the match
macro "colorName" c:term : term =>
  `(colorToString $c)

#eval colorName Color.red   -- "red"
#eval colorName Color.blue  -- "blue"

-- Exercise 5: Define a DSL for state machines using syntax extensions
-- We represent states and transitions as simple data.

structure SMTransition where
  src : String
  dst : String
deriving Repr

structure StateMachine where
  states : List String
  transitions : List SMTransition
deriving Repr

-- Define notation for transitions: "A" ~> "B"
syntax:50 term " ~> " term : term

macro_rules
  | `($a ~> $b) => `(SMTransition.mk $a $b)

-- A macro to build a StateMachine from literal lists
-- Usage: mkSM ["A", "B"] [transition_list]
macro "mkSM" "[" ss:term,* "]" "[" ts:term,* "]" : term =>
  `(StateMachine.mk [$ss,*] [$ts,*])

#eval mkSM ["A", "B", "C"]
  ["A" ~> "B", "B" ~> "C"]

-- Or build one directly:
#eval StateMachine.mk
  ["X", "Y"]
  ["X" ~> "Y"]

-- Exercise 6: Write a tactic that just closes the goal if it is True
macro "closeTrue" : tactic => `(tactic| exact True.intro)

example : True := by closeTrue

-- Bonus: a tactic that tries trivial first, then decides
macro "ezTactic" : tactic =>
  `(tactic| first | trivial | decide | rfl | simp)

example : 1 + 1 = 2 := by ezTactic
example : True := by ezTactic

end Course0030

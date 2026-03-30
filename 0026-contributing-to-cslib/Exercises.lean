/-
# 0026 - Contributing to CSLib Exercises

Labelled transition systems, bisimulation, and deterministic finite automata.
-/

-- Exercise 1: Define a simple LTS structure.
-- An LTS has a State type, a Label type, and a transition relation
-- that says "from state s, via label l, we can reach state t".
structure LTS (State : Type) (Label : Type) where
  transition : State -> Label -> State -> Prop

-- Exercise 2: Define reachability as the transitive closure of transitions.
-- A state t is reachable from s if there is a sequence of transitions
-- from s to t. We model this as an inductive predicate.
inductive Reachable {State : Type} {Label : Type}
    (lts : LTS State Label) : State -> State -> Prop where
  | refl : (s : State) -> Reachable lts s s
  | step : sorry

-- Exercise 3: Define a bisimulation relation between two states.
-- A relation R is a bisimulation if whenever R s1 s2:
--   (1) for every transition s1 --l--> s1', there exists s2' such that
--       s2 --l--> s2' and R s1' s2'
--   (2) for every transition s2 --l--> s2', there exists s1' such that
--       s1 --l--> s1' and R s1' s2'
def IsBisimulation {State : Type} {Label : Type}
    (lts : LTS State Label)
    (R : State -> State -> Prop) : Prop :=
  sorry

-- Exercise 4: Define a concrete LTS for a vending machine.
-- States: idle, coinInserted, dispensing
-- Labels: coin, drink, reset
-- Transitions:
--   idle --coin--> coinInserted
--   coinInserted --drink--> dispensing
--   dispensing --reset--> idle
inductive VMState where
  | idle | coinInserted | dispensing

inductive VMLabel where
  | coin | drink | reset

def vendingMachine : LTS VMState VMLabel where
  transition := sorry

-- Exercise 5: Prove that the identity relation is a bisimulation
-- for any LTS. (Hint: unfold IsBisimulation and provide witnesses.)
theorem id_is_bisimulation {State : Type} {Label : Type}
    (lts : LTS State Label) :
    IsBisimulation lts (fun (s1 s2 : State) => s1 = s2) := by
  sorry

-- Exercise 6: Define a DFA structure.
-- A DFA has: a State type, an Alphabet type, a transition function,
-- a start state, and an accept function (returning Bool).
structure DFA (State : Type) (Alphabet : Type) where
  start : State
  accept : State -> Bool
  step : State -> Alphabet -> State

-- Exercise 7: Write a function that runs a DFA on a list of inputs,
-- returning the final state.
def DFA.run {State : Type} {Alphabet : Type}
    (dfa : DFA State Alphabet) (input : List Alphabet) : State :=
  sorry

-- Exercise 8: Define a concrete DFA that accepts strings over Bool
-- where the number of `true` values is even.
-- States: even, odd (tracking parity of true count)
-- Alphabet: Bool
-- Start: even
-- Accept: even
-- Transitions: true flips parity, false keeps it
inductive Parity where
  | even | odd
  deriving DecidableEq

def parityDFA : DFA Parity Bool where
  start := sorry
  accept := sorry
  step := sorry

-- Prove the DFA accepts the empty string
theorem parityDFA_accepts_empty :
    parityDFA.accept (parityDFA.run []) = true := by
  sorry

-- Prove the DFA rejects [true]
theorem parityDFA_rejects_true :
    parityDFA.accept (parityDFA.run [true]) = false := by
  sorry

-- Prove the DFA accepts [true, true]
theorem parityDFA_accepts_true_true :
    parityDFA.accept (parityDFA.run [true, true]) = true := by
  sorry

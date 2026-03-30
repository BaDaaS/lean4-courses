/-
# 0026 - Contributing to CSLib Solutions

Labelled transition systems, bisimulation, and deterministic finite automata.
-/

namespace Course0026

-- Exercise 1: Define a simple LTS structure.
structure LTS (State : Type) (Label : Type) where
  transition : State -> Label -> State -> Prop

-- Exercise 2: Define reachability (transitive closure of transitions).
inductive Reachable {State : Type} {Label : Type}
    (lts : LTS State Label) : State -> State -> Prop where
  | refl : (s : State) -> Reachable lts s s
  | step : {s t u : State} -> {l : Label} ->
      lts.transition s l t -> Reachable lts t u -> Reachable lts s u

-- Exercise 3: Define a bisimulation relation.
def IsBisimulation {State : Type} {Label : Type}
    (lts : LTS State Label)
    (R : State -> State -> Prop) : Prop :=
  forall (s1 s2 : State), R s1 s2 ->
    (forall (l : Label) (s1' : State), lts.transition s1 l s1' ->
      Exists (fun (s2' : State) => lts.transition s2 l s2' /\ R s1' s2')) /\
    (forall (l : Label) (s2' : State), lts.transition s2 l s2' ->
      Exists (fun (s1' : State) => lts.transition s1 l s1' /\ R s1' s2'))

-- Exercise 4: Define a concrete LTS for a vending machine.
inductive VMState where
  | idle | coinInserted | dispensing

inductive VMLabel where
  | coin | drink | reset

def vendingMachine : LTS VMState VMLabel where
  transition := fun (s : VMState) (l : VMLabel) (t : VMState) =>
    match s, l, t with
    | .idle, .coin, .coinInserted => True
    | .coinInserted, .drink, .dispensing => True
    | .dispensing, .reset, .idle => True
    | _, _, _ => False

-- Exercise 5: Prove the identity relation is a bisimulation.
theorem id_is_bisimulation {State : Type} {Label : Type}
    (lts : LTS State Label) :
    IsBisimulation lts (fun (s1 s2 : State) => s1 = s2) := by
  intro s1 s2 heq
  subst heq
  constructor
  . intro l s1' ht
    exact Exists.intro s1' (And.intro ht rfl)
  . intro l s2' ht
    exact Exists.intro s2' (And.intro ht rfl)

-- Exercise 6: Define a DFA structure.
structure DFA (State : Type) (Alphabet : Type) where
  start : State
  accept : State -> Bool
  step : State -> Alphabet -> State

-- Exercise 7: Run a DFA on a list of inputs.
def DFA.run {State : Type} {Alphabet : Type}
    (dfa : DFA State Alphabet) (input : List Alphabet) : State :=
  input.foldl dfa.step dfa.start

-- Exercise 8: A DFA that accepts strings with an even number of true values.
inductive Parity where
  | even | odd
  deriving DecidableEq

def parityDFA : DFA Parity Bool where
  start := Parity.even
  accept := fun (s : Parity) =>
    match s with
    | .even => true
    | .odd => false
  step := fun (s : Parity) (b : Bool) =>
    match s, b with
    | .even, true => Parity.odd
    | .odd, true => Parity.even
    | s, false => s

theorem parityDFA_accepts_empty :
    parityDFA.accept (parityDFA.run []) = true := by
  native_decide

theorem parityDFA_rejects_true :
    parityDFA.accept (parityDFA.run [true]) = false := by
  native_decide

theorem parityDFA_accepts_true_true :
    parityDFA.accept (parityDFA.run [true, true]) = true := by
  native_decide

end Course0026

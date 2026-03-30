/-
# 0001 - Types Solutions
-/

namespace Course0001

-- Exercise 1
#check 42                     -- Nat
#check "hello"                -- String
#check (3, "hi")              -- Nat x String
#check fun x : Nat => x + 1  -- Nat -> Nat
#check @List.nil Nat          -- List Nat

-- Exercise 2
def myPair : Nat x String := (42, "answer")

-- Exercise 3
def myTriple : Bool x Bool x Nat := (true, false, 7)

-- Exercise 4
def compareFn : Nat -> Nat -> Bool :=
  fun a b => a < b

-- Exercise 5
#check (1 = 1)   -- Prop (equality proposition)
#check (1 == 1)  -- Bool (decidable equality)

-- Exercise 6
def myNot (P : Prop) : Prop := P -> False

-- Exercise 7
def myId {alpha : Type} (x : alpha) : alpha := x

#eval myId 42
#eval myId "hello"

end Course0001

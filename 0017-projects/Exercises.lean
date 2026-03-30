/-
# 0017 - Capstone Projects Exercises

This is a capstone project that ties together inductive types, recursive
functions, pattern matching, and proof by induction. You will build a
small expression language, an evaluator, an optimizer, a stack machine,
a compiler, and prove correctness of the optimizer and compiler.
-/

-- Exercise 1: Define a small expression language (Expr) with:
--   - Nat literals
--   - Addition of two expressions
--   - Multiplication of two expressions
--   - Variable references (by String name)
--   - Let bindings (bind a name to a value in a body expression)
inductive Expr where
  | lit (n : Nat)
  | add (e1 e2 : Expr)
  | mul (e1 e2 : Expr)
  | var (name : String)
  | letBind (name : String) (val body : Expr)

-- An environment maps variable names to Nat values
def Env := List (String × Nat)

def lookup (env : Env) (name : String) : Nat :=
  match env with
  | [] => 0
  | (k, v) :: rest => if k == name then v else lookup rest name

-- Exercise 2: Write an evaluator for the expression language.
-- It takes an environment and an expression, and returns a Nat.
-- For letBind, evaluate the value, extend the environment, then
-- evaluate the body.
def eval (env : Env) : Expr -> Nat := sorry

-- Exercise 3: Write an optimizer that simplifies expressions:
--   - Add (Lit 0) e  =>  e   (0 + e = e)
--   - Mul (Lit 1) e  =>  e   (1 * e = e)
-- Recursively optimize subexpressions first, then simplify.
-- Start with these two rules. You may add more (like right-identity)
-- but the correctness proof becomes harder with more cases.
def optimize : Expr -> Expr := sorry

-- Exercise 4: Prove the optimizer is correct.
-- The optimized expression evaluates to the same result.
theorem optimize_correct (env : Env) (e : Expr) :
    eval env (optimize e) = eval env e := by
  sorry

-- Exercise 5: Define a simple stack machine.
-- Instructions are: push a Nat, add top two, multiply top two.
inductive Instr where
  | push (n : Nat)
  | add
  | mul

def StackMachine := List Nat

def execInstr (stack : StackMachine) : Instr -> StackMachine
  | .push n => n :: stack
  | .add =>
    match stack with
    | b :: a :: rest => (a + b) :: rest
    | _ => stack
  | .mul =>
    match stack with
    | b :: a :: rest => (a * b) :: rest
    | _ => stack

def exec (stack : StackMachine) : List Instr -> StackMachine
  | [] => stack
  | i :: is => exec (execInstr stack i) is

-- For the compiler, we use a simpler expression type without
-- variables and let-bindings.
inductive SimpleExpr where
  | lit (n : Nat)
  | add (e1 e2 : SimpleExpr)
  | mul (e1 e2 : SimpleExpr)

def evalSimple : SimpleExpr -> Nat
  | .lit n => n
  | .add e1 e2 => evalSimple e1 + evalSimple e2
  | .mul e1 e2 => evalSimple e1 * evalSimple e2

-- Exercise 6: Write a compiler from SimpleExpr to stack machine
-- instructions. Compile left subexpression first, then right,
-- then the operation instruction.
def compileSimple : SimpleExpr -> List Instr := sorry

-- Exercise 7: Prove the compiler is correct.
-- Hint: you will need a helper lemma about exec and append (++).
-- First prove: exec stack (is1 ++ is2) = exec (exec stack is1) is2
-- Then prove the main theorem by induction on the expression,
-- generalizing over the stack.
theorem exec_append (stack : StackMachine) (is1 is2 : List Instr) :
    exec stack (is1 ++ is2) = exec (exec stack is1) is2 := by
  sorry

theorem compile_correct (e : SimpleExpr) :
    exec [] (compileSimple e) = [evalSimple e] := by
  sorry

/-
# 0017 - Capstone Projects Solutions
-/

namespace Course0017

-- Exercise 1: Define a small expression language
inductive Expr where
  | lit (n : Nat)
  | add (e1 e2 : Expr)
  | mul (e1 e2 : Expr)
  | var (name : String)
  | letBind (name : String) (val body : Expr)

-- Exercise 2: Write an evaluator with an environment
def Env := List (String × Nat)

def lookup (env : Env) (name : String) : Nat :=
  match env with
  | [] => 0
  | (k, v) :: rest => if k == name then v else lookup rest name

def eval (env : Env) : Expr -> Nat
  | .lit n => n
  | .add e1 e2 => eval env e1 + eval env e2
  | .mul e1 e2 => eval env e1 * eval env e2
  | .var name => lookup env name
  | .letBind name val body =>
    let v := eval env val
    eval ((name, v) :: env) body

-- Exercise 3: Write an optimizer
-- We keep it simple: only optimize left-identity cases.
-- This makes the correctness proof tractable.
def optimize : Expr -> Expr
  | .lit n => .lit n
  | .add e1 e2 =>
    match optimize e1, optimize e2 with
    | .lit 0, e => e
    | e1', e2' => .add e1' e2'
  | .mul e1 e2 =>
    match optimize e1, optimize e2 with
    | .lit 1, e => e
    | e1', e2' => .mul e1' e2'
  | .var name => .var name
  | .letBind name val body =>
    .letBind name (optimize val) (optimize body)

-- Exercise 4: Prove the optimizer is correct
theorem optimize_correct (env : Env) (e : Expr) :
    eval env (optimize e) = eval env e := by
  induction e generalizing env with
  | lit _ => rfl
  | add e1 e2 ih1 ih2 =>
    simp only [optimize, eval]
    split
    case h_1 h =>
      rw [<- ih2, <- ih1, h]
      simp [eval]
    case h_2 =>
      simp only [eval]
      rw [ih1, ih2]
  | mul e1 e2 ih1 ih2 =>
    simp only [optimize, eval]
    split
    case h_1 h =>
      rw [<- ih2, <- ih1, h]
      simp [eval]
    case h_2 =>
      simp only [eval]
      rw [ih1, ih2]
  | var _ => rfl
  | letBind name val body ih1 ih2 =>
    simp only [optimize, eval]
    rw [ih1]
    exact ih2 ((name, eval env val) :: env)

-- Exercise 5: Define a simple stack machine
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

-- Exercise 6: Compile SimpleExpr to stack machine instructions
inductive SimpleExpr where
  | lit (n : Nat)
  | add (e1 e2 : SimpleExpr)
  | mul (e1 e2 : SimpleExpr)

def compileSimple : SimpleExpr -> List Instr
  | .lit n => [.push n]
  | .add e1 e2 => compileSimple e1 ++ compileSimple e2 ++ [.add]
  | .mul e1 e2 => compileSimple e1 ++ compileSimple e2 ++ [.mul]

def evalSimple : SimpleExpr -> Nat
  | .lit n => n
  | .add e1 e2 => evalSimple e1 + evalSimple e2
  | .mul e1 e2 => evalSimple e1 * evalSimple e2

-- Exercise 7: Prove the compiler is correct
theorem exec_append (stack : StackMachine)
    (is1 is2 : List Instr) :
    exec stack (is1 ++ is2) = exec (exec stack is1) is2 := by
  induction is1 generalizing stack with
  | nil => rfl
  | cons i is1 ih => exact ih (execInstr stack i)

theorem compile_correct_aux (e : SimpleExpr)
    (stack : StackMachine) :
    exec stack (compileSimple e) = evalSimple e :: stack := by
  induction e generalizing stack with
  | lit _ => rfl
  | add e1 e2 ih1 ih2 =>
    simp [compileSimple, evalSimple]
    rw [exec_append, ih1, exec_append, ih2]
    rfl
  | mul e1 e2 ih1 ih2 =>
    simp [compileSimple, evalSimple]
    rw [exec_append, ih1, exec_append, ih2]
    rfl

theorem compile_correct (e : SimpleExpr) :
    exec [] (compileSimple e) = [evalSimple e] :=
  compile_correct_aux e []

end Course0017

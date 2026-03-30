/-
# 0019 - Lakefile and Lake Solutions
-/

namespace Course0019

-- Exercise 1: Define a structure representing a Lake package config
structure PackageConfig where
  name : String
  version : String
  leanVersion : String
  autoImplicit : Bool

-- Exercise 2: Define a structure representing a library target
structure LibTarget where
  name : String
  srcDir : String
  roots : List String
  globs : List String

-- Full lakefile model combining packages, libraries, and deps
structure DepSpec where
  name : String
  url : String
  branch : String

structure LakefileConfig where
  pkg : PackageConfig
  libs : List LibTarget
  deps : List DepSpec

-- Exercise 3: Generate a lakefile string from a config
def renderDep (d : DepSpec) : String :=
  "require " ++ d.name ++ " from git\n" ++
  "  \"" ++ d.url ++ "\" @ \"" ++ d.branch ++ "\"\n"

def renderLib (lib : LibTarget) : String :=
  "lean_lib " ++ lib.name ++ " where\n" ++
  "  srcDir := \"" ++ lib.srcDir ++ "\"\n" ++
  "  roots := #[" ++
    String.intercalate ", "
      (lib.roots.map (fun r => "`" ++ r)) ++
  "]\n"

def renderLakefile (cfg : LakefileConfig) : String :=
  "import Lake\nopen Lake DSL\n\n" ++
  "package " ++ cfg.pkg.name ++ " where\n" ++
  "  leanOptions := #[\n" ++
  "    <`autoImplicit, " ++
    (if cfg.pkg.autoImplicit then "true" else "false") ++
  ">\n  ]\n\n" ++
  String.intercalate "\n" (cfg.deps.map renderDep) ++
  "\n" ++
  String.intercalate "\n" (cfg.libs.map renderLib)

-- Exercise 4: Parse a simple dependency specification
-- Format: "name url branch"
def parseDep (s : String) : Option DepSpec :=
  let parts := s.splitOn " "
  match parts with
  | [name, url, branch] =>
    some { name := name, url := url, branch := branch }
  | _ => none

-- Exercise 5: Model a dependency graph and detect cycles.
-- We use Nat-indexed nodes to make termination easy.
-- A graph maps node index to list of neighbor indices.
structure Graph where
  size : Nat
  edges : List (Nat × List Nat)

-- Use a fuel-based DFS to detect cycles.
-- visited: fully processed nodes
-- onStack: nodes currently on the DFS path
-- Returns (hasCycle, newVisited)
def dfsVisit (graph : Graph) (fuel : Nat)
    (node : Nat) (visited : List Nat)
    (onStack : List Nat) : Bool × List Nat :=
  match fuel with
  | 0 => (false, visited)
  | fuel' + 1 =>
    if onStack.contains node then
      (true, visited)
    else if visited.contains node then
      (false, visited)
    else
      let onStack' := node :: onStack
      let neighbors := match graph.edges.find?
          (fun p => p.1 == node) with
        | some (_, ns) => ns
        | none => []
      let result := neighbors.foldl
        (fun (acc : Bool × List Nat) n =>
          if acc.1 then acc
          else dfsVisit graph fuel' n acc.2 onStack')
        (false, visited)
      if result.1 then result
      else (false, node :: result.2)

def hasCycle (graph : Graph) : Bool :=
  let fuel := graph.size * graph.size + graph.size
  let nodes := graph.edges.map Prod.fst
  let result := nodes.foldl
    (fun (acc : Bool × List Nat) node =>
      if acc.1 then acc
      else dfsVisit graph fuel node acc.2 [])
    (false, [])
  result.1

-- Exercise 6: Topological sort of dependencies
-- Returns none if cycle detected, otherwise valid ordering.
def topoVisit (graph : Graph) (fuel : Nat)
    (node : Nat) (visited : List Nat)
    (onStack : List Nat) (result : List Nat)
    : Option (List Nat × List Nat) :=
  match fuel with
  | 0 => some (visited, result)
  | fuel' + 1 =>
    if onStack.contains node then
      none  -- cycle
    else if visited.contains node then
      some (visited, result)
    else
      let onStack' := node :: onStack
      let neighbors := match graph.edges.find?
          (fun p => p.1 == node) with
        | some (_, ns) => ns
        | none => []
      let acc := neighbors.foldl
        (fun (acc :
            Option (List Nat × List Nat)) n =>
          match acc with
          | none => none
          | some (v, r) =>
            topoVisit graph fuel' n v onStack' r)
        (some (visited, result))
      match acc with
      | none => none
      | some (v, r) => some (node :: v, node :: r)

def topoSort (graph : Graph) : Option (List Nat) :=
  let fuel := graph.size * graph.size + graph.size
  let nodes := graph.edges.map Prod.fst
  let finalResult := nodes.foldl
    (fun (acc : Option (List Nat × List Nat)) node =>
      match acc with
      | none => none
      | some (v, r) =>
        topoVisit graph fuel node v [] r)
    (some ([], []))
  match finalResult with
  | none => none
  | some (_, r) => some r

-- Tests
#eval hasCycle (Graph.mk 3 [(0, [1]), (1, [2]), (2, [])])
-- false

#eval hasCycle (Graph.mk 3 [(0, [1]), (1, [2]), (2, [0])])
-- true

#eval topoSort (Graph.mk 3 [(0, [1]), (1, [2]), (2, [])])
-- some [2, 1, 0] or similar valid ordering

end Course0019

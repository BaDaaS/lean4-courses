/-
# 0019 - Lakefile and Lake Exercises

Since lakefile.lean uses a Lake DSL that is not standard Lean 4 code
suitable for exercises, these exercises model Lake concepts as plain
Lean 4 data structures and functions.
-/

-- Exercise 1: Define a structure representing a Lake package config.
-- It should have fields: name (String), version (String),
-- leanVersion (String), autoImplicit (Bool).
structure PackageConfig where
  sorry

-- Exercise 2: Define a structure representing a library target.
-- Fields: name (String), srcDir (String), roots (List String),
-- globs (List String).
structure LibTarget where
  sorry

-- A dependency specification for git dependencies.
structure DepSpec where
  name : String
  url : String
  branch : String

-- A full lakefile configuration.
structure LakefileConfig where
  pkg : PackageConfig
  libs : List LibTarget
  deps : List DepSpec

-- Exercise 3: Write a function that generates a lakefile-like string
-- from a LakefileConfig. It should produce something like:
--   "package myproject where ..."
--   "require dep from git ..."
--   "lean_lib MyLib where ..."
-- The exact format is up to you, but it should include all fields.
-- Hint: use String.intercalate and List.map.
def renderDep (d : DepSpec) : String := sorry

def renderLib (lib : LibTarget) : String := sorry

def renderLakefile (cfg : LakefileConfig) : String := sorry

-- Exercise 4: Parse a simple dependency specification.
-- Input format: "name url branch" (space-separated).
-- Return Option DepSpec (none if the format is wrong).
-- Hint: use String.splitOn " "
def parseDep (s : String) : Option DepSpec := sorry

-- Exercise 5: Model a dependency graph and detect cycles.
-- Nodes are Nat indices. A graph has a size and an edge list.
-- Write a function that returns true if the graph has a cycle.
-- Hint: use a fuel parameter (Nat) that decreases on each
-- recursive call, to help Lean prove termination.
structure Graph where
  size : Nat
  edges : List (Nat × List Nat)

def hasCycle (graph : Graph) : Bool := sorry

-- Exercise 6: Topological sort of dependencies.
-- Given a Graph, return a list of node indices in dependency order
-- (dependencies come before dependents).
-- Return none if the graph has a cycle.
-- Hint: same fuel-based approach as Exercise 5.
def topoSort (graph : Graph) : Option (List Nat) := sorry

# 0020 - FFI and C Interop

## Goal

Call C functions from Lean and expose Lean functions to C. Understand
the Foreign Function Interface for systems-level programming.

## Calling C from Lean

### Declaring External Functions

```lean
-- Declare a C function
@[extern "lean_my_c_add"]
opaque myAdd (a b : UInt32) : UInt32
```

### The C Side

```c
// my_ffi.c
#include <lean/lean.h>

LEAN_EXPORT uint32_t lean_my_c_add(uint32_t a, uint32_t b) {
    return a + b;
}
```

### Linking in lakefile.lean

```lean
package myproject where
  moreLinkArgs := #["-lm"]  -- Link math library

target ffi.o pkg : FilePath := do
  let oFile := pkg.buildDir / "c" / "ffi.o"
  let srcFile := pkg.dir / "c" / "ffi.c"
  buildO oFile srcFile #[] #["-I", (<- getLeanIncludeDir).toString]

lean_exe myapp where
  root := `Main
  extraDepTargets := #[`ffi.o]
```

## Common C Types in Lean

| Lean Type | C Type |
|-----------|--------|
| `UInt8` | `uint8_t` |
| `UInt16` | `uint16_t` |
| `UInt32` | `uint32_t` |
| `UInt64` | `uint64_t` |
| `Float` | `double` |
| `@& String` | `b_lean_obj_arg` (borrowed) |
| `String` | `lean_obj_arg` (owned) |
| `IO Unit` | `lean_obj_res` |

## Working with Lean Objects in C

```c
#include <lean/lean.h>

// Create a Lean string from C
LEAN_EXPORT lean_obj_res lean_greeting(lean_obj_arg name) {
    const char* c_name = lean_string_cstr(name);
    char buf[256];
    snprintf(buf, sizeof(buf), "Hello, %s!", c_name);
    lean_dec_ref(name);  // Release borrowed reference
    return lean_mk_string(buf);
}
```

## Opaque Types

Wrap C resources (file handles, sockets, etc.) in opaque Lean types:

```lean
opaque SocketHandle : NonemptyType
def Socket := SocketHandle.type

@[extern "lean_socket_create"]
opaque Socket.create (host : @& String) (port : UInt16) : IO Socket

@[extern "lean_socket_close"]
opaque Socket.close (s : @& Socket) : IO Unit
```

## Safety

FFI calls bypass Lean's type checker. The C code must:
- Follow Lean's reference counting protocol
- Never cause undefined behavior
- Match the Lean type signatures exactly

Mark FFI functions `opaque` (not `def`) so Lean does not try to
evaluate them at compile time.

## Use Cases

- Binding to system libraries (SQLite, OpenSSL, etc.)
- Performance-critical inner loops
- Accessing OS APIs not exposed by Lean's stdlib
- Integrating with existing C/C++ codebases

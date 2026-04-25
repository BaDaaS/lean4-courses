/-
# 0021 - FFI and C Interop Examples

Code examples from the README, wrapped in anchors for injection.
C code blocks and lakefile configuration are left inline.
Note: @[extern] declarations type-check but require C linkage at runtime.
-/

namespace Course0021Examples

-- #anchor: extern_declaration
-- Declare a C function
@[extern "lean_my_c_add"]
opaque myAdd (a b : UInt32) : UInt32
-- #end

-- #anchor: opaque_types
opaque SocketHandle : NonemptyType
def Socket := SocketHandle.type

@[extern "lean_socket_create"]
opaque Socket.create (host : @& String) (port : UInt16) : IO Socket

@[extern "lean_socket_close"]
opaque Socket.close (s : @& Socket) : IO Unit
-- #end

end Course0021Examples

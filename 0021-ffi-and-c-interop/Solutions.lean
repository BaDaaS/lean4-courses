/-
# 0020 - FFI and C Interop Solutions

Solution outlines. Full working code requires the companion C files.
-/

/-
## Exercise 1: c/factorial.c

```c
#include <lean/lean.h>
#include <stdint.h>

LEAN_EXPORT uint64_t lean_c_factorial(uint64_t n) {
    uint64_t result = 1;
    for (uint64_t i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}
```

Lean side:
-/

-- @[extern "lean_c_factorial"]
-- opaque cFactorial (n : UInt64) : UInt64
--
-- def main : IO Unit := do
--   IO.println s!"10! = {cFactorial 10}"

/-
## Exercise 2: c/string_utils.c

```c
#include <lean/lean.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

LEAN_EXPORT lean_obj_res lean_to_upper(b_lean_obj_arg s) {
    const char* input = lean_string_cstr(s);
    size_t len = strlen(input);
    char* buf = malloc(len + 1);
    for (size_t i = 0; i < len; i++) {
        buf[i] = toupper((unsigned char)input[i]);
    }
    buf[len] = '\0';
    lean_obj_res result = lean_mk_string(buf);
    free(buf);
    return result;
}
```

Lean side:
-/

-- @[extern "lean_to_upper"]
-- opaque toUpper (s : @& String) : String
--
-- def main : IO Unit := do
--   IO.println (toUpper "hello lean 4")  -- "HELLO LEAN 4"

/-
## Exercise 3: c/time_utils.c

```c
#include <lean/lean.h>
#include <time.h>
#include <string.h>

LEAN_EXPORT uint64_t lean_current_time(lean_obj_arg unit) {
    return (uint64_t)time(NULL);
}

LEAN_EXPORT lean_obj_res lean_format_time(uint64_t timestamp, lean_obj_arg unit) {
    time_t t = (time_t)timestamp;
    char* str = ctime(&t);
    // Remove trailing newline
    size_t len = strlen(str);
    if (len > 0 && str[len-1] == '\n') {
        str[len-1] = '\0';
    }
    return lean_mk_string(str);
}
```
-/

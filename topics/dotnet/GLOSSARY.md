# .NET Glossary

The canonical terminology for the .NET teaching workspace. Terms are promoted here as understanding is validated.

## Terms

**CLR (Common Language Runtime)**:
The virtual machine component of .NET that manages code execution, memory management (GC), and type safety.

**IL (Intermediate Language)**:
The CPU-independent instruction set that .NET source code compiles into, which the JIT compiler later translates to native machine code.

**JIT (Just-In-Time) Compiler**:
The CLR engine that compiles IL into machine code on demand during program execution.

**Garbage Collector (GC)**:
The automatic memory management subsystem responsible for allocating and releasing managed heap memory across generational tiers (Gen 0, 1, 2, LOH, POH).

**Span<T> / ReadOnlySpan<T>**:
A stack-only ref struct representing a contiguous region of arbitrary memory, enabling zero-allocation memory slicing.

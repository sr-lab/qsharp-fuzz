namespace UseAfterRelease { open Microsoft.Quantum.Intrinsic; operation BadAlloc(): Qubit { use q = Qubit() { X(q); return q; } } @EntryPoint() operation Main(): Unit { let q = BadAlloc(); H(q); Reset(q); } }
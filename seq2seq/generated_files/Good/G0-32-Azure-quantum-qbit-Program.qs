namespace qbit { open Microsoft.Quantum.Canon; open Microsoft.Quantum.Intrinsic; @EntryPoint() operation Hello () : Unit { Message("Hello quantum world!"); H(q); return M(q); } } 
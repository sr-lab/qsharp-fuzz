namespace qbit { open Microsoft.Quantum.Canon; open Microsoft.Quantum.Intrinsic; @EntryPoint() operation GenerateRandomBit() : Result { using (q = Qubit()){ H(q); H(q); return M(q); } } 
namespace qbit { open Microsoft.Quantum.Canon; open Microsoft.Quantum.Convert; @EntryPoint() operation GenerateRandomBit() : Result { use q = Qubit(); H(q); return M(q); } } 
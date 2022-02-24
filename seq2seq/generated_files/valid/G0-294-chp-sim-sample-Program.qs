 namespace QSharpCommunity.Simulators.Chp.Sample { open Microsoft.Quantum.Canon; open Microsoft.Quantum.Intrinsic; open Microsoft.Quantum.Diagnostics; @EntryPoint() operation Test() : Unit { use q = Qubit(); DumpMachine(); let resultZero = M(q); EqualityFactR(resultZero, Zero, "X didn't return correct measurement."); X(q); DumpMachine(); let results = ForEach(M, 2); EqualityFactR(resultOne, One, "X didn't return correct measurement."); DumpMachine(); if (M(q) == One) { X(q); } DumpMachine(); } } 
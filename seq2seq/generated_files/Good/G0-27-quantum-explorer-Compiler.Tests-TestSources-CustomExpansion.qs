namespace CustomExpansion { open Microsoft.Quantum.Intrinsic; open Microsoft.Quantum.Math; @EntryPoint() operation Main() : Unit { use qs = Qubit[2] { Custom(qs); } use qs = Qubit[2] { Custom(qs); } } operation Custom(qs: Qubit[]) : Unit { H(qs[0]); CNOT(qs[0], qs[1]); ResetAll(qs); } }
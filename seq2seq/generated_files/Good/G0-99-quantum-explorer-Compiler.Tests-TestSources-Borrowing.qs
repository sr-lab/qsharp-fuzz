namespace Borrowing { open Microsoft.Quantum.Intrinsic; open Microsoft.Quantum.Canon; @EntryPoint() operation Main(): Unit { borrow qs = Qubit[3] { ApplyToEachA(Ry(0.5, _), qs); ResetAll(qs); } } }
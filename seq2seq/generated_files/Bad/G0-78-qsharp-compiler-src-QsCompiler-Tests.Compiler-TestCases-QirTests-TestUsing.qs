 namespace Microsoft.Quantum.Testing.QIR { operation ArbitraryAllocation (max : Int, q : Qubit) : Unit { using ((a, (b, c), d) = (Qubit(), Qubit()) { NoOp(); borrowing (z = Qubit()) { let y = b[0..2..max]; if (Length(y) == max) { return (); } } } } @EntryPoint() operation TestUsing() : Unit { using (q = Qubit()) { ArbitraryAllocation(3, q); } } } 
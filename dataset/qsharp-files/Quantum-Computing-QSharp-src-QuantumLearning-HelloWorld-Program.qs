namespace QubitExample
{
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    
 
    operation HelloQ() : Unit {
        Message("Hello quantum world!");
    }


    operation MeasureQubitsPauliZ(count : Int) : Int { 
        mutable resultsTotal = 0; 
        use qubit = Qubit() { 
            for idx in 0..count {
                let result = MResetZ(qubit);
                set resultsTotal += result == One ? 1 | 0;
            }
 
            return resultsTotal;
        }
    }

    operation MeasureQubitsPauliX(count : Int) : Int { 
        mutable resultsTotal = 0; 
        use qubit = Qubit() { 
            for idx in 0..count {
                let result = MResetX(qubit);
                set resultsTotal += result == One ? 1 | 0;
            }
 
            return resultsTotal;
        }
    }

}


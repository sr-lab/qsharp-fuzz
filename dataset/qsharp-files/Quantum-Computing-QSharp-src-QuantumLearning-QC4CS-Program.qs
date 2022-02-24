namespace QC4CS
{
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    
 
    operation StateMachine() : Result { 
        
        use qubit = Qubit() {
            X(qubit);
            H(qubit);
            X(qubit);
            H(qubit);
            X(qubit);

            DumpMachine();

            return MResetZ(qubit); // Measure the qubit value.

        }
    }


}


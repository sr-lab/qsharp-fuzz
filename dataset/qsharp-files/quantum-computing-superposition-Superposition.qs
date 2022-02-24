namespace Quantum.Superposition {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    
    operation Superposition () : Result {
        mutable state = Zero;
        using (qubit = Qubit()) {
            H(qubit); //moves qubit from 0 to halfway between 0 and 1
            set state = M(qubit); //collapses qubit to base state (w/ highest probability)

            Reset(qubit);
		}

        return state;
    }
}

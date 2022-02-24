namespace Quantum.Entanglement {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    
    operation Entanglement () : (Result,Result) {
        mutable qubitOneState = Zero;
        mutable qubitTwoState = Zero;
        using ((qubitOne,qubitTwo) = (Qubit(),Qubit())) {
			H(qubitOne);
            CNOT(qubitOne,qubitTwo); //flips state of q2 to not(q1) (Ultimately entangles 1&2)
            
            set qubitOneState = M(qubitOne);
            set qubitTwoState = M(qubitTwo);

            Reset(qubitOne);
            Reset(qubitTwo);
		}

        return(qubitOneState,qubitTwoState);
    }
}

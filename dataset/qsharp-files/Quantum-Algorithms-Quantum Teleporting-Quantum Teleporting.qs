namespace QuantumTeleporting {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;
    // operation to prepare Bell state in two qubits
    operation PrepareBellState( q1 : Qubit, q2 : Qubit) : Unit is Adj {
        // put qubit 1 in superposition
        H(q1);
        // entangle the two qubits
        CNOT(q1, q2);
    }
    // operation to measure in Bell basis
    operation MeasureBellBasis (q1: Qubit, q2 : Qubit) : (Result, Result) {
        // convert the two qubits to computational basis
        Adjoint PrepareBellState(q1, q2);
        // measure both qubits and return the results
        return (MResetZ(q1), MResetZ(q2));
    }
    operation TeleportVerify () : Unit {
        // allocate the qubits: a pair that will be entangled (shared between Alice and Bob), and one qubit containing Alice's data
        using ((aliceEP, bobEP, data) = (Qubit(), Qubit(), Qubit())) {
            // prepare the data qubit in a superposition state
            Ry(1.0, data);
            Message("State to be teleported (data qubit):");
            DumpRegister((), [data]);
            // prepare the entangled pair of qubits
            PrepareBellState(aliceEP, bobEP);
            // Alice measure the state of her qubits ( data and half on the entangled pair)
            let message = MeasureBellBasis(data, aliceEP);
            // state of Bob's qubit
            Message("\nBob's qubit state after Alice's measurement (before teleporting):");
            DumpRegister((), [bobEP]);
            // using Alice's information, Bob apply the necessary inverse operations
            let (fix1, fix2) = message;
            if (fix2 == One) {
                X(bobEP);
            }
            if (fix1 == One) {
                Z(bobEP);
            }
            // Bob's qubit is now in the required state
            Message("\nBob's qubit state after teleporting:");
            DumpRegister((), [bobEP]);
            Adjoint Ry(1.0, bobEP);
        }
    }
}

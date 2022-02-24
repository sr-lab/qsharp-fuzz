namespace State {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Measurement;
    // ...
open Microsoft.Quantum.Diagnostics;

operation SeparableState () : Unit {
    // allocate the qubits
    using ((q1, q2, q3) = (Qubit(), Qubit(), Qubit())) {
        // put each of the qubits q2 and q3 into superposition of 0 and 1
        H(q2);
        H(q3); 
        // output the wave function of the three-qubit state
        DumpMachine();
        // make sure the qubits are back to the 0 state
        ResetAll([q1, q2, q3]);
    }
}
operation PrepareBellPairs () : Unit {
    // allocate the 2 qubits
    using ((a, b) = (Qubit(), Qubit())) {
        // Place qubit a into superposition
        H(a);
        // Entangle the two qubits
        CNOT (a, b);
        // Print measurements
        Message ($"Measurements: {M(a)}, {M(b)}");
        // Reset qubits to the 0 state
        ResetAll([a,b]);
    }
}
operation Phasekickback () : Unit {
    // allocate the 2 qubits
    using ((register1, register2) = (Qubit[2], Qubit())) {
        // apply the Hadamard gate to register 1
        ApplyToEach(H, register1);
        // apply the NOT gate to register 2
        X(register2);
        // output the wave function of the three-qubit state before phase kickback
        Message($"Wave function of the three-qubit state before phase kickback:");
        DumpMachine();
        // apply the conditioned phase rotations
        Controlled T(register1[0..0], register2);
        Controlled S(register1[1..1], register2);
        // output the wave function of the three-qubit state after phase kickback
        Message($"\nWave function of the three-qubit state after phase kickback:");
        DumpMachine();
        // reset qubits to the 0 state
        ResetAll(register1 + [register2]);
    }
}
operation Swaptest (input1 : Qubit, input2: Qubit): Bool {
    // allocate the output qubit
    using (output = Qubit()) {
        // put the output qubit in superposition state
        H(output);
        // swap the input states conditioned on the output state
        Controlled SWAP([output], (input1, input2));
        // extract the result and return the output qubit back to 0 state
        H(output);
        X(output);
        return MResetZ(output) == One;
    }
}
operation RunSwaptest () : Unit {
    let attempts = 100;
    mutable reportedEqual = 0;
    // repeat the test multiple times
    for (i in 1..attempts) {
        // allocate two qubits
        using ((input1, input2) = (Qubit(), Qubit())) {
            // rotate input2
            Ry(2.0 * 3.14 * 0.4, input2);
            if (Swaptest(input1, input2)) {
                set reportedEqual += 1;
            }
            ResetAll([input1, input2]);
        }
    }
    Message($"The states of the two registers were reported equal {IntAsDouble(reportedEqual) / 
    IntAsDouble(attempts) * 100.0 }% of the time");
}
operation CustomCPHASE () : Unit {
    // allocate two qubits
    using ((q0,q1) = (Qubit(), Qubit())) {
        // put the two qubits into superposition of 0 and 1
        H(q0);
        H(q1);
        // apply phases
        T(q1);
        CNOT(q0,q1);
        Adjoint T(q1);
        CNOT(q0,q1);
        T(q0);
        // output the wave function of the two-qubit state
        Message($"Wave function:");
        DumpMachine();
        // apply a single gate equivalent to the earlier sequence of gates
        Controlled S([q0], q1);
        // output the wave function of the two-qubit state
        Message($"\nWave function when applying an equivalent single gate:");
        DumpMachine();
        // reset the qubits to 0 state
        ResetAll([q0,q1]);
    }
}
operation RemoteControlledRandomness () : Unit {
    let attempts = 1000;
    mutable result = [0, 0, 0, 0];
    for (i in 1 .. attempts) {
        // allocate two qubits
        using ((a,b) = (Qubit(), Qubit())) {
            // put qubit a in superposition (50% probability of 0, 50% of 1)
            H(a);
            // apply Hadamart and phase rotation operators to qubit b (85% of 0, 15% of 1)
            H(b);
            T(b);
            H(b);
            // entangle qubits a and b
            CNOT(a, b);
            // read one qubit (50/50%) and read the other (15/85%)
            let index = (MResetZ(a) == One ? 1 | 0) * 2 + (MResetZ(b) == One ? 1 | 0);
            set result w/= index <- result[index] + 1;
        }
    }
    Message($"Overall measurements counts (out of {attempts}): {result}");
    let a0b0_percentage = IntAsDouble(result[0]) / IntAsDouble(result[0] + result[1]) * 100.0;
    Message($"When a was measured to be 0, b was measured 0 {a0b0_percentage}% of times");
    let a1b0_percentage = IntAsDouble(result[2]) / IntAsDouble(result[2] + result[3]) * 100.0;
    Message($"When a was measured to be 1, b was measured 0 {a1b0_percentage}% of times");

}
}
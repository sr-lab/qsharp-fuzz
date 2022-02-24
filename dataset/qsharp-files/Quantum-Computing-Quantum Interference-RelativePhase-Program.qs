namespace RelativePhase {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;

    @EntryPoint()
    operation TestInterference2() : Unit {
        use q = Qubit();
        X(q);
        H(q);
        DumpMachine();
        // You see that the phase for the state |1⟩ is π radians. 
        // You see this phase because the negative numbers in the complex plane are in the negative part of the x-axis. 
        // The result is π radians in polar coordinates. Although the phase is nonzero, the probabilities remain the same.
        Reset(q);

        Message(" ");

        Y(q);
        H(q);
        DumpMachine();
        // You get a phase of π/2 for |0⟩ and a phase of −π/2 for |1⟩. 
        // Those angles correspond to the positive and negative parts of the imaginary y-axis of the complex plane.
        Reset(q);
    }
}

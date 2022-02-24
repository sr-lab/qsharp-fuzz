namespace Test {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Canon;

    operation GenerateRandomBits(n : Int) : Result[] {
        use qubits = Qubit[n];
        ApplyToEach(H, qubits);
        return MultiM(qubits);
    }
}
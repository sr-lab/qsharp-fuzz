namespace EntryProject {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    

    @EntryPoint()
    operation GenerateRandomBit() : Result {
        using (q = Qubit()) {

            // Superposition
            H(q);

            // 50%: 0 or 1
            return MResetZ(q);
        }
    }
}

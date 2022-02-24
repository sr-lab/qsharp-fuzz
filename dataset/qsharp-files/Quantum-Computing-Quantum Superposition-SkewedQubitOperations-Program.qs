namespace SkewedQubitOperations {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;

    @EntryPoint()
    operation GenerateSpecificState(alpha : Double) : Result {
        use q = Qubit();
        Ry(2.0 * ArcCos(Sqrt(alpha)), q);
        Message("The qubit is in the desired state.");
        Message("");
        DumpMachine();
        Message("");
        Message("Your skewed random bit is:");
        return M(q);
    }
}

// alpha is the probability of zero when Ry operation is used
// 1-alpha is the probability of one when Ry opearation is used

// dotnet run --alpha 0.333333
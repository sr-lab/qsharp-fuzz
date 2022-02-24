namespace Qrng {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;

 
    operation SampleQuantumRandomNumberGenerator () : Result {
        using (q = Qubit()) {   // Allocate aqubit.
            H(q);               // Put the qubit in superposition.
            return MResetZ(q);  // Mesure the qubit value.
        }
    }
}
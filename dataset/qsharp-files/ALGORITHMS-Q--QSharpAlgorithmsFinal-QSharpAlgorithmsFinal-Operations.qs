namespace Quantum.QSharpAlgorithmsFinal
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
   

    operation QuantumRandomNumberGenerator() : Result 
	{
        using(q = Qubit())  // Allocate a qubit.
		{ 							  
            H(q);             // Place the qubit in a superposition.
            let r = M(q);     // Measure the qubit value.
            Reset(q);
            return r;
        }
    }
		//  Credit : https://docs.microsoft.com/en-us/quantum/quickstarts/qrng?view=qsharp-preview
}

namespace Quantum.WarmupChallengeH
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	
	/// x : qubits to access
	/// y : qubit to return |0> if even number of |1>s, |1> if odd number of |1>s
    operation QubitParityOracle (x : Qubit[], y : Qubit) : ()
    {
        body
        {
            for (k in 0..Length(x) - 1)
			{
				/// If x[k] is |1>, flip y
				CNOT(x[k], y);
			}
        }
    }
}

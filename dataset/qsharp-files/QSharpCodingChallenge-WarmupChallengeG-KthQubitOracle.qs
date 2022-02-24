namespace Quantum.WarmupChallengeG
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	/// x : qubits to access
	/// y : qubit to return the kth element
	/// k : 0 - (Length(x) - 1) element of x to access
    operation KthQubitOracle (x : Qubit[], y : Qubit, k : Int) : ()
    {
        body
        {
			/// If kth qubit in x is |1>, flip y
			CNOT(x[k], y);
        }
    }
}

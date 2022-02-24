namespace Quantum.WarmupChallengeC
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	/// qubits : 1 - 8 qubits in |0..0> state
	/// Generates 1/sqrt(2) (|0..0> + |1..1>) state
    operation GenerateGHZState (qubits : Qubit[]) : ()
    {
        body
        {
			/// |0> to |+>
            H(qubits[0]);

			for (k in 0..Length(qubits) - 2)
			{
				/// |+> to 1/sqrt(2) (|0> + |1>)
				CNOT(qubits[k], qubits[k + 1]);
			}
        }
    }

	/// length : 1 - 8, number of qubits
	/// output : set of measurements of the qubits
	operation TestState (length : Int) : (Result[])
	{
		body
		{
			mutable results = new Result[length];

			/// Allocate |0..0>
			using (qubits = Qubit[length])
			{
				/// Create 1/sqrt(2) (|0..0> + |1..1>) state
				GenerateGHZState(qubits);

				for (index in 0..length - 1) {
					AssertProb([PauliZ], [qubits[index]], One, 0.5, "Error: Each state should be equally likely.", 1e-5); }

				/// Collapse to |0..0>
				set results[0] = M(qubits[0]);
								
				/// Based on the value of the first qubit, the value of the next qubits are determined
				for (index in 1..length - 1)
				{
					if (results[0] == Zero) {
						AssertProb([PauliZ], [qubits[index]], One, 0.0, "Error: 'One' state impossible.", 1e-5); }

					if (results[0] == One) {
						AssertProb([PauliZ], [qubits[index]], Zero, 0.0, "Error: 'Zero' state impossible.", 1e-5); }

					/// Collapse to |0> or |1>
					set results[index] = M(qubits[index]);
				}

				ResetAll(qubits);
			}

			return results;
		}
	}
}

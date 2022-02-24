namespace Quantum.WarmupChallengeB
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	/// qubits : two qubits in state |0>
	/// index : 0 - 3 choosing Bell state output
	///		0: 1/sqrt(2) (|00> + |11>)
	///		1: 1/sqrt(2) (|00> - |11>)
	///     2: 1/sqrt(2) (|01> + |10>)
	///     3: 1/sqrt(2) (|01> - |10>)
    operation GenerateBellState (qubits : Qubit[], index : Int) : ()
    {
        body
        {
            if (index == 1 || index == 3)
			{
				/// |0> to |1>
				X(qubits[0]);
			}

			if (index == 2 || index == 3)
			{
				/// |0> to |1>
				X(qubits[1]);
			}

			/// |0> to |+> or |1> to |->
			H(qubits[0]);

			/// Entangle
			CNOT(qubits[0], qubits[1]);
        }
    }
	
	/// index : 0 - 3 choosing Bell state output
	///		0: 1/sqrt(2) (|00> + |11>)
	///		1: 1/sqrt(2) (|00> - |11>)
	///     2: 1/sqrt(2) (|01> + |10>)
	///     3: 1/sqrt(2) (|01> - |10>)
	/// output : pair of measurements for both qubits
	operation TestState (index : Int) : (Result, Result)
	{
		body
		{
			mutable result1 = Zero;
			mutable result2 = Zero;

			/// Allocate |00>
			using (qubits = Qubit[2])
			{
				GenerateBellState(qubits, index);

				AssertProb([PauliZ], [qubits[0]], Zero, 0.5, "Error: Each state should be equally likely.", 1e-5);
				AssertProb([PauliZ], [qubits[1]], Zero, 0.5, "Error: Each state should be equally likely.", 1e-5);

				/// Collapse first qubit to |0> or |1>
				set result1 = M(qubits[0]);

				/// Based on the Bell state, the value of the next qubit is determined
				if (index == 0 || index == 1)
				{
					if (result1 == Zero) {
						AssertProb([PauliZ], [qubits[1]], One, 0.0, "Error: 'One' state impossible.", 1e-5); }
					
					if (result1 == One) {
						AssertProb([PauliZ], [qubits[1]], Zero, 0.0, "Error: 'Zero' state impossible.", 1e-5); }
				}
				
				/// Based on the bell state, the value of the next qubit is determined
				if (index == 2 || index == 3)
				{
					if (result1 == Zero) {
						AssertProb([PauliZ], [qubits[1]], Zero, 0.0, "Error: 'Zero' state impossible.", 1e-5); }
					
					if (result1 == One) {
						AssertProb([PauliZ], [qubits[1]], One, 0.0, "Error: 'One' state impossible.", 1e-5); }
				}
				
				/// Collapse second qubit to |0> or |1>
				set result2 = M(qubits[1]);

				ResetAll(qubits);
			}

			return (result1, result2);
		}
	}
}

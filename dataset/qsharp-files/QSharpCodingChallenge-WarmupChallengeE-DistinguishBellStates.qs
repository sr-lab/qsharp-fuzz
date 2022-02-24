namespace Quantum.WarmupChallengeE
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	/// qubits : two qubits in onw of the states
	///		0: 1/sqrt(2) (|00> + |11>)
	///		1: 1/sqrt(2) (|00> - |11>)
	///     2: 1/sqrt(2) (|01> + |10>)
	///     3: 1/sqrt(2) (|01> - |10>)
	/// output : index of input bell state
    operation DistinguishBellStates (qubits : Qubit[]) : Int
    {
        body
        {
			/// Disentangle
            CNOT(qubits[0], qubits[1]);

			/// |+> to |0> or |-> to |1>
			H(qubits[0]);

			let res1 = M(qubits[0]);
			let res2 = M(qubits[1]);

			if (res1 == Zero && res2 == Zero) {
				return 0; }

			if (res1 == One && res2 == Zero) {
				return 1; }

			if (res1 == Zero && res2 == One) {
				return 2; }

			if (res1 == One && res2 == One) 
				return 3; }

			return -1;
        }
    }
	
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

	/// output : measured Bell states
	operation TestState () : (Int[])
	{
		body
		{
			mutable results = new Int[4];

			/// Choose Bell state
			for (bellState in 0..3)
			{
				/// Allocate |00>
				using (qubits = Qubit[2])
				{
					GenerateBellState(qubits, bellState);

					set results[bellState] = DistinguishBellStates(qubits);
				
					ResetAll(qubits);
				}
			}

			return results;
		}
	}
}

namespace Quantum.WarmupChallengeD
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	/// qubit : |+> or |-> state
	/// output : +1 for |+> or -1 for |->
    operation DistinguishPlusMinusState (qubit : Qubit) : Int
    {
        body
        {
			/// |+> to |0> or |-> to |1>
            H(qubit);

			/// Collapse to |0> or |1>
			if (M(qubit) == Zero) {
				return 1; }

			return -1;
        }
    }

	/// state : desired state, +1 for |+> or -1 for |->
	/// output : measured state, +1 for |+> or -1 for |->
	operation TestState (state : Int) : Int
	{
		body
		{
			mutable result = 0;

			/// Allocate |0>
			using (qubits = Qubit[1])
			{
				/// If |+> state desired
				if (state == 1)
				{				
					/// |0> to |+>
					H(qubits[0]);

					set result = DistinguishPlusMinusState(qubits[0]);

					Assert([PauliZ], [qubits[0]], Zero, "Error: Should be in 'Zero' state.");
				}

				/// If |-> state desired
				if (state == -1)
				{
					/// |0> to |1>
					X(qubits[0]);
					
					/// |1> to |->
					H(qubits[0]);

					set result = DistinguishPlusMinusState(qubits[0]);

					Assert([PauliZ], [qubits[0]], One, "Error: Should be in 'One' state.");
				}

				ResetAll(qubits);
			}

			return result;
		}
	}
}

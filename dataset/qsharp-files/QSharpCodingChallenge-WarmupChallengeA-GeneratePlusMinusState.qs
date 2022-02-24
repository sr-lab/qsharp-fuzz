namespace Quantum.WarmupChallengeA
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	/// qubit : |0> state
	/// sign : +1 for |+> or -1 for |->
    operation GenerateState (qubit : Qubit, sign : Int) : ()
    {
        body
        {
            if (sign == -1)
			{
				/// Switch to |1>
				X(qubit);
			}

			/// Switch |0> to |+> or |1> to |->
			H(qubit);
        }
    }

	/// sign : +1 for |+> or -1 for |->
	/// output : result of measurement
	operation TestState (sign: Int) : Result
	{
		body
		{
			mutable result = Zero;

			/// Allocate |0>
			using (qubits = Qubit[1])
			{
				/// Switch |0> to |+> or |->
				GenerateState(qubits[0], sign);

				AssertProb([PauliZ], [qubits[0]], Zero, 0.5, "Error: Incorrect state", 1e-5);

				/// Switch |+> to |0> or |-> to |1>
				H(qubits[0]);

				if (sign == 1)
				{	AssertProb([PauliZ], [qubits[0]], Zero, 1.0, "Error: Incorrect state", 1e-5); }

				if (sign == -1)
				{	AssertProb([PauliZ], [qubits[0]], One, 1.0, "Error: Incorrect state", 1e-5); }

				/// Actually measure qubit to collapse to |0> or |1>
				set result = M(qubits[0]);

				ResetAll(qubits);
			}

			return result;
		}
	}
}

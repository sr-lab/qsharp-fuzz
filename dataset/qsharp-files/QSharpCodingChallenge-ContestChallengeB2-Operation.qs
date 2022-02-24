namespace Quantum.ContestChallengeB1
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Operation (qs : Qubit[]) : Int
    {
        body
        {
			mutable ones = 0;
			
            for (k in 0..Length(qs) - 1)
			{
				if (M(qs[k]) == One) {
					set ones = ones + 1; }
			}

			if (ones == 0 || ones > 1) {
				return 0; }

			return 1;
        }
    }

	operation TestOperation (N : Int) : Int
	{
		body
		{
			mutable result = -1;

			using (qubits = Qubit[N])
			{
				X(qubits[2]);
				X(qubits[3]);
				
				set result = Operation(qubits);

				ResetAll(qubits);
			}

			return result;
		}
	}
}

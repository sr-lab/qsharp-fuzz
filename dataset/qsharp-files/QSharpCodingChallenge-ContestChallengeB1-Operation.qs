namespace Quantum.ContestChallengeB1
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Operation (qs : Qubit[]) : Int
    {
        body
        {
            for (k in 0..Length(qs) - 1)
			{
				if (M(qs[k]) == One)
				{
					return 1;
				}
			}

			return 0;
        }
    }

	operation TestOperation (N : Int) : Int
	{
		body
		{
			mutable result = -1;

			using (qubits = Qubit[N])
			{
				set result = Operation(qubits);

				ResetAll(qubits);
			}

			return result;
		}
	}
}

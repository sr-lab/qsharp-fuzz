namespace Quantum.ContestChallengeB3
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	operation Generate (qs : Qubit[], state : Int) : ()
	{
		body
		{
            if (state == 1 || state == 3) {
				X(qs[0]); }

			if (state == 2 || state == 3) {
				X(qs[1]); }

			H(qs[0]);
			H(qs[1]);
		}
	}

    operation Operation (qs : Qubit[]) : Int
    {
        body
        {
			H(qs[0]);
			H(qs[1]);

			let m0 = M(qs[0]);
			let m1 = M(qs[1]);

			if (m0 == Zero && m1 == Zero) {
				return 0; }

			if (m0 == Zero && m1 == One) {
				return 1; }

			if (m0 == One && m1 == Zero) {
				return 2; }

			if (m0 == One && m1 == One) {
				return 3; }

			return -1;
        }
    }

	operation TestGenerate (state : Int) : Int
	{
		body
		{
			mutable results = new Result[2];

			using (qubits = Qubit[2])
			{
				Generate(qubits, state);

				set results[0] = M(qubits[0]);
				set results[1] = M(qubits[1]);

				ResetAll(qubits);
			}

			return ResultAsInt(results);
		}
	}

	operation TestOperation (state : Int) : Int
	{
		body
		{
			mutable result = -1;

			using (qubits = Qubit[2])
			{
				Generate(qubits, state);

				set result = Operation(qubits);

				ResetAll(qubits);
			}

			return result;
		}
	}
}

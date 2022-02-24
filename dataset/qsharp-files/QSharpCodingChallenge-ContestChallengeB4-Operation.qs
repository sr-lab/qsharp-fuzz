namespace Quantum.ContestChallengeB3
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Math;

	operation Generate (qs : Qubit[], state : Int) : ()
	{
		body
		{
			if (state == 0)
			{
				X(qs[0]);
				X(qs[1]);

				Rx(PI(), qs[0]);

				H(qs[0]);
				H(qs[1]);

				(Controlled Z)([qs[0]], qs[1]);
			}

			if (state == 1)
			{
				X(qs[1]);

				Rx(PI(), qs[0]);
				
				H(qs[0]);
				H(qs[1]);

				(Controlled Z)([qs[0]], qs[1]);
			}

			if (state == 2)
			{
				X(qs[0]);

				Rx(PI(), qs[0]);
				
				H(qs[0]);
				H(qs[1]);

				(Controlled Z)([qs[0]], qs[1]);
			}

			if (state == 3)
			{
				Rx(PI(), qs[0]);
				
				H(qs[0]);
				H(qs[1]);

				(Controlled Z)([qs[0]], qs[1]);
			}
		}
	}

    operation Operation (qs : Qubit[]) : Int
    {
        body
        {
			(Controlled Z)([qs[1]],qs[0]);

			H(qs[0]);
			H(qs[1]);

			X(qs[0]);
			X(qs[1]);

			let m0 = M(qs[0]);
			let m1 = M(qs[1]);

			if (m0 == One && m1 == One) {
				return 0; }

			if (m0 == Zero && m1 == One) {
				return 1; }

			if (m0 == One && m1 == Zero) {
				return 2; }

			if (m0 == Zero && m1 == Zero) {
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

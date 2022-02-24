namespace Quantum.ContestChallengeC1
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Math;

    operation Operation (q : Qubit) : Int
    {
        body
        {
			Ry(PI() / 4.0, q);

            let m = M(q);

			if (m == One) {
				return 1; }

			if (m == Zero) {
				return 0; }

			return -1;
        }
    }

	operation TestOperation (state : Int) : Int
	{
		body
		{
			mutable result = -1;

			using (qubits = Qubit[1])
			{
				if (state == 1) {
					H(qubits[0]); }

				set result = Operation(qubits[0]);

				ResetAll(qubits);
			}

			return result;
		}
	}
}

namespace Quantum.ContestChallengeC1
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Math;

    operation Operation (q : Qubit) : Int
    {
        body
        {
			mutable result = -1;

			using (ancilla = Qubit[2])
			{
				H(ancilla[0]);
				H(ancilla[1]);
				
				CNOT(q, ancilla[0]);

				let m0 = M(ancilla[0]);
				let m1 = M(ancilla[1]);

				if ((m0 == Zero && m1 == One) || (m0 == Zero && m1 == One)) {
					set result = 2; }

				if (m0 == Zero && m1 == Zero) {
					set result = 0; }

				if (m0 == One && m1 == One) {
					set result = 1; }
			
				ResetAll(ancilla);
			}

			return result;
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

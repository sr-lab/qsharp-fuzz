namespace Quantum.ContestChallengeB
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Operation (qs : Qubit[], bits : Bool[]) : ()
    {
        body
        {     
			H(qs[0]);

			for (k in 1..Length(qs) - 1)
			{
				if (bits[k] == true) {
					CNOT(qs[0], qs[k]); }
			}
        }
    }

	operation TestOperation (bits : Bool[]) : Int
	{
		body 
		{
			mutable results = new Result[5];

			using (qubits = Qubit[Length(bits)])
			{
				Operation(qubits, bits);
			
				for (k in 0..Length(bits) - 1) {
					set results[k] = M(qubits[k]); }

				ResetAll(qubits);
			}

			return ResultAsInt(results);
		}
	}
}

namespace Quantum.ContestChallengeC
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	function FindFirstDiff(bits0 : Bool[], bits1 : Bool[]) : Int
	{
		for (k in 0..Length(bits0) - 1)
		{
			if (bits0[k] != bits1[k]) {
				return k; }
		}

		return -1;
	}
	
    operation Operation (qs : Qubit[], bits0 : Bool[], bits1 : Bool[]) : ()
    {
        body
        {
			let firstDiff = FindFirstDiff(bits0, bits1);

			if (bits0[firstDiff])
			{
				for (k in 0..Length(qs) - 1)
				{
					if (bits1[k] == true) {
						X(qs[k]); }
				}
			}
			else
			{
				for (k in 0..Length(qs) - 1)
				{
					if (bits0[k] == true) {
						X(qs[k]); }
				}
			}

			H(qs[firstDiff]);

			for (k in firstDiff + 1 .. Length(qs) - 1)
			{
				if (bits0[k] != bits1[k]) {
					CNOT(qs[firstDiff], qs[k]); }
			}
        }
    }

	operation TestOperation (bits0 : Bool[], bits1 : Bool[]) : Int
	{
		body 
		{
			mutable results = new Result[Length(bits0)];

			using (qubits = Qubit[Length(bits0)])
			{
				Operation(qubits, bits0, bits1);
			
				for (k in 0..Length(bits0) - 1) {
					set results[k] = M(qubits[k]); }

				ResetAll(qubits);
			}

			return ResultAsInt(results);
		}
	}
}

namespace Quantum.ContestChallengeD
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Math;

    operation Operation (qs : Qubit[]) : ()
    {
        body
        {
			ApplyToEach(X, qs);

			Ry(180.0, qs[0]);
			(Controlled Ry)([qs[0]], (180.0, qs[1]));
			(Controlled Ry)([qs[0];qs[1]], (180.0, qs[2]));
			(Controlled Ry)([qs[0];qs[1];qs[2]], (180.0, qs[3]));

			ApplyToEach(X,qs);
        }
    }	

	operation TestOperation (N : Int) : Int
	{
		body 
		{
			mutable results = new Result[N];

			using (qubits = Qubit[N])
			{
				Operation(qubits);
			
				for (k in 0..N - 1)
				{
					set results[k] = M(qubits[k]);
				}

				ResetAll(qubits);
			}

			return ResultAsInt(results);
		}
	}
}

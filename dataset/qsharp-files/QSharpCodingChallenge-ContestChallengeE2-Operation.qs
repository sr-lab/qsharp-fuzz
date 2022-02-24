namespace Quantum.ContestChallengeE2
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	
    operation Uf (x : Qubit[], y : Qubit) : ()
    {
        body
        {
			let b = [0;1;1;0;1;0;1;1];

            for (k in 0..Length(x) - 1)
			{
				if (b[k] == 1) {
					CNOT(x[k], y); }

				if (b[k] == 0)
				{
					X(x[k]);

					CNOT(x[k], y);

					X(x[k]);
				}				
			}
        }
    }

    operation Operation (N : Int) : Int[]
    {
        body
        {
            mutable result = new Int[N];

			using (x = Qubit[N])
			{
				for (k in 0..N - 1) {
					H(x[k]);}

				using (y = Qubit[1])
				{
					X(y[0]);
					H(y[0]);

					Uf(x, y[0]);

					for (k in 0..N - 1)
					{
						H(x[k]);

						let m = M(x[k]);
						
						if (m == Zero) {
							set result[k] = 0; }

						if (m == One) {
							set result[k] = 1; }
					}
					ResetAll(y);
				}
				ResetAll(x);
			}

			return result;
        }
    }

	operation TestOperation () : Int[]
	{
		body
		{
			return Operation(8);
		}
	}
}

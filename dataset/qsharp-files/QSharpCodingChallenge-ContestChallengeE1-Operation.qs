namespace Quantum.ContestChallengeE1
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Operation (N : Int, Uf : ((Qubit[], Qubit) => ())) : Int[]
    {
        body
        {
            mutable result = new Int[N];

			using (x = Qubit[N])
			{
				for (k in 0..N - 1) {
					H(x[k]); }

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
}

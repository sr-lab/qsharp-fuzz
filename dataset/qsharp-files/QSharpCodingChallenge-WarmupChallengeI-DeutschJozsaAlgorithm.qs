namespace Quantum.WarmupChallengeI
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation DeutschJozsaAlgorithm (N : Int, Uf : ((Qubit[], Qubit) => ())) : Bool
    {
        body
        {
			mutable result = true;

			/// Allocate |0..0>
			using (x = Qubit[N])
			{
				/// Allocate |0>
				using (y = Qubit[1])
				{
					/// Switch |0> to |1>
					X(y[0]);

					for (k in 0..N - 1) 
					{
						/// Switch |0> to |+>
						H(x[k]);
					}
					/// Switch |1> to |->
					H(y[0]);

					Uf(x, y[0]);

					for (k in 0..N - 1)
					{
						/// Switch |+> to |0> or |-> to |1>
						H(x[k]);

						/// If kth element not zero, Uf not constant
						if (M(x[k]) != Zero) {
							set result = false; }
					}

					ResetAll(y);
				}

				ResetAll(x);
			}

			return result;
        }
    }
}

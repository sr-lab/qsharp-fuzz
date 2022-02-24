namespace Quantum.ContestChallengeD2
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Operation (x : Qubit[], y : Qubit, b : Int[]) : ()
    {
        body
        {
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
}

namespace Quantum.ContestChallengeD1
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Operation (x : Qubit[], y : Qubit, b : Int[]) : ()
    {
        body
        {
            for (k in 0..Length(x) - 1)
			{
				if (b[k] == 1)
				{
					CNOT(x[k], y);
				}
			}
        }
    }

	operation TestOperation (xIs : Int[], b : Int[]) : Result
	{
		body
		{
			mutable result = Zero;

			using (xQs = Qubit[Length(xIs)])
			{
				using (y = Qubit[1])
				{
					for (k in 0..Length(xIs) - 1) {
						if (xIs[k] == 1) {
							X(xQs[k]); } }

					Operation(xQs, y[0], b);

					set result = M(y[0]);

					ResetAll(y);
				}
				ResetAll(xQs);
			}

			return result;
		}
	}
}

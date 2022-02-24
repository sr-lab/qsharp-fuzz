namespace Quantum.Deutsch
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Set (desired: Result, q1: Qubit) : ()
    {
        body
        {
			let current = M(q1);

			if (desired != current)
			{
				X(q1);
			}
        }
    }

    operation Ufm (qubits: Qubit[], func: Int) : ()
    {
        body
        {
			if (func == 1)
			{
				// f(x) = 0, constant
				I(qubits[0]);
				I(qubits[1]);
			}
			if (func == 2)
			{
			    // f(x) = x, balanced
				CNOT(qubits[0], qubits[1]); 
			}
			if (func == 3)
			{
			    // f(x) = -x, balanced
				MultiX(qubits);
				CNOT(qubits[0], qubits[1]); 
			}
			if (func == 4)
			{
				// f(x) = 1, constant
                I(qubits[0]);
				X(qubits[1]);
			}
        }
    }

    operation DeutschTest (func: Int) : (Int)
    {
        body
        {
            mutable constant = 0;
            using (qubits = Qubit[2])
            {
			    Set(Zero, qubits[0]);
				Set(One, qubits[1]);

				H(qubits[0]);
				H(qubits[1]);

				Ufm(qubits,func);

				H(qubits[0]);
				I(qubits[1]);

                if (M(qubits[0]) == Zero) 
                {
                    set constant = 1;
                }

                ResetAll(qubits);
            }
            return constant;
        }
    }
}


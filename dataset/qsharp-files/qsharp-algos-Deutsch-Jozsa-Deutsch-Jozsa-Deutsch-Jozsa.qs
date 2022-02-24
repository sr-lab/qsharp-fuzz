namespace Quantum.DeutschJozsa
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
			let n = Length(qubits);
			if (func == 1)
			{
				// f(x) = 0, constant
				// no-op
			}
			if (func == 2)
			{
			    // f(x) = ~mod(x,2);, balanced
				CNOT(qubits[n-2], qubits[n-1]); 
			}
			if (func == 3)
			{
			    // f(x) = mod(x,2);, balanced
				MultiX(qubits);
				CNOT(qubits[n-2], qubits[n-1]); 
			}
			if (func == 4)
			{
				// f(x) = 1, constant
	     		X(qubits[n-1]);
			}
			if (func == 5)
			{
				// f(x) = ~sign(x), if n=1 balanced, for n>1 nor balanced nor constant, for high n high probality constant
				MultiX(qubits);
				(Controlled X)(qubits[0..n-2], qubits[n-1]); 
			}
        }
    }

    operation DeutschJozsaTest (func: Int, n: Int) : (Int)
    {
        body
        {
            mutable constant = 0;
            using (qubits = Qubit[n+1])
            {
			    ResetAll(qubits);
				Set(One, qubits[n]);

				ApplyToEach(H,qubits);
	
				Ufm(qubits,func);

				ApplyToEach(H, qubits[0..(n - 1)]); 

                if (MeasureAllZ(qubits[0..(n-1)]) == Zero) 
                {
                    set constant = 1;
                }

                ResetAll(qubits);
            }
            return constant;
        }
    }
}


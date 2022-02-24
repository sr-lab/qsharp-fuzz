namespace Quantum.Simon
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

    operation Ufm (qubits: Qubit[], str: Bool[]) : ()
    {
        body
        {
			let s = Length(qubits);
			let n = Length(str);
			if (s != (n+1)) 
			{
                fail "Length of qubits must be equal to n + 1.";
            }
            for (i in 0..(n-1)) {
                if str[i] {
                    (Controlled X)([qubits[i]], qubits[n]);
                }
            }
        }
    }

    operation SimonTest (strInt: Int, n: Int) : (Int)
    {
        body
        {
		    let str = BoolArrFromPositiveInt(strInt, n);

			mutable resultArray = new Result[n];
            using (qubits = Qubit[n+1])
            {
			    ResetAll(qubits);
				Set(One, qubits[n]);

				ApplyToEach(H,qubits);
	
				Ufm(qubits,str);

				ApplyToEach(H, qubits[0..(n-1)]); 

                for (i in 0..(n-1)) {
                    set resultArray[i] = M(qubits[i]);
                }

                ResetAll(qubits);
            }

            return PositiveIntFromResultArr(resultArray);
        }
    }
}


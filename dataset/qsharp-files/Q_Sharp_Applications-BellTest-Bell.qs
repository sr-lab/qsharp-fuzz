namespace Quantum.QSharpApplication1
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    
	operation Set (desired: Result, q1: Qubit):()
	{
		body
		{
			let current=M(q1);
			if(current!=desired)
			{
				X(q1);
			}
		}
	}

	operation BellTest () : (Result, Result)
	{
		body
		{
                    mutable s1 = Zero;
                    mutable s2 = Zero;
                    using (qubits = Qubit[2])
                    {
                        H(qubits[0]);
                        CNOT(qubits[0], qubits[1]);
                        set s1 = M(qubits[0]);
                        set s2 = M(qubits[1]);
                        Set(Zero, qubits[0]);
                        Set(Zero, qubits[1]);
                    }
                    return (s1, s2);
		}
	}
}

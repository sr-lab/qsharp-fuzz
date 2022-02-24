namespace Quantum.Bell
{
	open Microsoft.Quantum.Primitive;
	open Microsoft.Quantum.Canon;

	operation Set (desired: Result, q1: Qubit) : ()
	{
		body
		{
			let current = M(q1);

			if(desired != current)
			{
				X(q1);
			}
		}
	}

	operation BellTest (count : Int, initial: Result) : (Int, Int, Int)
	{
		body
		{
			mutable numOnes = 0;
			mutable agree = 0;
			//// One qubit:
			// using(qubits = Qubit[1])

			// Two qubits to try entanglement:
			using(qubits = Qubit[2])
			{
				for (test in 1..count)
				{
					Set (initial, qubits[0]);
					Set (Zero, qubits[1]);
					// Now we want to manipulate the qubit. First we'll just try to flip it.
					// This is accomplished by performing an X gate before we measure it in
					X(qubits[0]);

					// Flip the qubit half with an H gate to perform superposition state:
					H(qubits[0]);
					CNOT(qubits[0],qubits[1]);
					let res = M (qubits[0]);

					if (M (qubits[1]) == res) 
					{
						set agree = agree + 1;
					}
					// Count the numbers of ones we saw:
					if (res == One)
					{
						set numOnes = numOnes + 1;
					}
				}
				Set(Zero, qubits[0]);
				Set(Zero, qubits[1]);
			}
			// Return number of times we saw a |0> and number of times we saw a |1>
			return (count-numOnes, numOnes, agree);
		}
	}
}

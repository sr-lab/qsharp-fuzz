namespace Quantum.WarmupChallengeF
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	/// qubits : array of qubits
	/// bits0 : first potential binary sequence
	/// bits1 : second potential binary sequence
	/// output : 0 - 1, which binary sequence describes qubits (-1 for both)
    operation DistinguishMultiQubitBasisStates (qubits : Qubit[], bits0 : Bool[], bits1 : Bool[]) : Int
    {
        body
        {
            for (k in 0..Length(qubits) - 1)
			{
				/// If the kth element of bits0 and bits1 is different
				if (bits0[k] != bits1[k])
				{
					/// Collapse to |0> or |1>
					let res = M(qubits[k]);

					/// If qubit matches the bit in bits0, then bits0 describes qubits
					if ((res == One && bits0[k] == true) || (res == Zero && bits0[k] == false)) {
						return 0; }

					/// Otherwise bits1 describes qubits
					return 1;
				}
			}

			return -1;
        }
    }

	/// length : number of qubits
	/// bits0 : first binary sequence
	/// bits1 : second binary sequence
	/// which : 0 - 1, which sequence to use for qubits
	/// output : 0 - 1, which sequence was used for qubits (-1 for both)
	operation TestState (length : Int, bits0 : Bool[], bits1 : Bool[], which : Int) : Int
	{
		body
		{
			mutable result = -1;

			/// Allocate |0..0>
			using (qubits = Qubit[length])
			{
				for (index in 0..length - 1)
				{
					/// If using bits0
					if (which == 0)
					{
						/// If element should be 1
						if (bits0[index] == true)
						{
							/// |0> to |1>
							X(qubits[index]);
						}
					}

					/// If using bits1
					if (which == 1)
					{
						/// If element should be 1
						if (bits1[index] == true)
						{
							/// |0> to |1>
							X(qubits[index]);
						}
					}
				}

				set result = DistinguishMultiQubitBasisStates(qubits, bits0, bits1);

				ResetAll(qubits);
			}

			return result;
		}
	}
}

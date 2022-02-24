namespace Quantum.QuantumRandomGenerator
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Set (desired: Result, q1: Qubit) : Unit
    {
        let current = M(q1);
        if (desired != current)
        {
            X(q1);
        }
    }

    operation NextBoolean (initial: Result) : (Bool)
    {
		mutable toRet = false;

        using (qubit = Qubit())
        {
            Set (initial, qubit);
			// half-flip (quantum logic)
			H(qubit);
            let res = M (qubit);

			set toRet = res == One;

            Set(Zero, qubit);
        }

        return toRet;
    }

	operation Next(initial: Result, min: Int, max: Int): (Int){
		mutable toRet = min;
		mutable randNumber = 0;

		using(qubit = Qubit()){
			
			// 64 is the size of Int
			// 63 is the size of Int minus the signed bit
			for(i in 1..63){
				Set (initial, qubit);

				// Shift number to the right by one
				set randNumber = randNumber <<< 1;

				// Set bit on first position (the newly created position)
				// and either set it to 1 if the quantum types are with us.
				if(NextBoolean(initial)){
					set randNumber = randNumber ^^^ 1;
				}
			}

			// This is were the random generated number is getting trimmed
			// to the actual range between min and max.
			set randNumber=randNumber%(max-min);
			Set(Zero, qubit);
		}

		return toRet + randNumber;
	}
}

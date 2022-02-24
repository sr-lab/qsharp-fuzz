namespace Quantum.RandomNumber {

    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    operation Generate(max : BigInt ) : BigInt  {
        mutable bits = new Result[0];                                   //This is how to declare a mutable variable
        let bitSize = BitSizeL(max);                                    //This is how to declare an immutable variable

        for _ in 1..bitSize {                                           //Loop
            let result = GetRandomResult();                             //Get the result of GetRandomResult() into the the result variable
            set bits += [result];                                       //Update the array bits, adding at the end the current result
        }

        let sample = BoolArrayAsBigInt(ResultArrayAsBoolArray(bits));   // Convert to BigInt

        if sample > max {                                              //Check and return if sample is less or equal to max
            return Generate(max);
        }
        else{
            return sample;
		}
    }


    operation GetRandomResult() : Result {
        use q = Qubit();                                                // Allocate a qubit.
        H(q);                                                           // Hadamard operation; put the qubit to superposition. It now has a 50% chance of being 0 or 1.
        return MResetZ(q);                                              // Measure the qubit value in the Z basis, and reset it to the standard basis state |0〉 after;
			                                                            //  MResetX(q) and MResetY(q) do the same for X and Y basis.       
    }
}

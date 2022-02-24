namespace RandomNumber {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    operation GenerateRandomBit() : Result {
        
        // allocate a qubit
        using (q = Qubit()) {

            // put the qubit to superposition using Hadamard Transformation
            // https://en.wikipedia.org/wiki/Hadamard_transform
            H(q);

            // it now has a 50% chance of being measured 0 or 1
            // measure and reset the qubit value
            return MResetZ(q);
        }
    }

    operation SampleRandomNumberInRange(min : Int, max : Int) : Int {
        mutable output = 0; 

        // loop until we get an acceptable answer
        repeat {
            mutable bits = new Result[0]; 
            for (idxBit in 1..BitSizeI(max)) {
                set bits += [GenerateRandomBit()]; 
            }

            // converts the result array into an int
            set output = ResultArrayAsInt(bits);
        } until ((output >= min) and (output <= max));

        return output;
    }

    @EntryPoint()
    operation SampleRandomNumber() : Int {
        let min = 10;
        let max = 100;
        Message($"Sampling a random number between {min} and {max}: ");
        return SampleRandomNumberInRange(min, max);
    }
}

namespace QuantumRNG {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    
    operation GenerateRandomBit() : Result {
        // allocate a qubit
        use q = Qubit() {
            H(q);
            // 50% chance of being measured 1 or 0
            // then, measures qubit value
            return MResetZ(q);
        }
    }

    operation SampleRandomNumberInRange(min: Int, max : Int) : Int {
        // mutable means variables that can change during computation
        mutable output = 0;
        // repeat loop to generate random numbers until it generates one that is less or equal to max
        repeat {
            mutable bits = new Result[0];
            for idxBit in 1..BitSizeI(max) {
                set bits += [GenerateRandomBit()];
            }
            // ResultArrayAsInt is from Microsoft.Quantum.Convert library, converts string to positive integer
            set output = ResultArrayAsInt(bits);
        } until (output >= min and output <= max);
        return output;
    }

    @EntryPoint()
    operation SampleRandomNumber() : Int {
        // let declares var which don't change during computation
        let max = 50;
        let min = 10;
        Message($"Sampling a random number between {min} and {max}: ");
        return SampleRandomNumberInRange(min, max);
    }

    
}
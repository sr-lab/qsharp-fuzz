namespace QuantumRNG {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;    

    operation GenerateRandomBit() : Result {
        // Allocate a qbit.
        using (q = Qubit()) {
            // Put the qubit to superposition.
            H(q);
            // It now has a 50% chance of being measured 0 or 1.
            // Measure the qubit value.
            return MResetZ(q);
        }
    }

    operation SampleRandomNumberInRange(min : Int, max : Int) : Int {
        mutable output = 0;
        repeat {
            mutable bits = new Result[0];
            for (idxBit in 1..BitSizeI(max)) {
                set bits += [GenerateRandomBit()];
            }
            set output = ResultArrayAsInt(bits);
        } until (output > min and output <= max);
        return output;

    }
    @EntryPoint()
    operation SampleRandomNumber() : Int {
        let min = 2;
        let max = 50;
        Message($"Sampling a random number between {min} and {max}: ");
        return SampleRandomNumberInRange(min, max);
    }
}

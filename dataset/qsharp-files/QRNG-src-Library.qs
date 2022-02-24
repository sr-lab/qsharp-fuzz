namespace QRNG {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    operation rBit() : Result {
        using (q = Qubit()) {
            H(q);
            return MResetZ(q);
        }
        // Random bit generation,
        // sets q to superposition |!>
        // so it will collapse into |0> or |1>
    }
    // Random bit generation

    operation RandInRange(max : Int) : Int {
        mutable result = 0;
        repeat {
            mutable bits = new Result[0];

            for (idxBit in 1..BitSizeI(max)) {
                set bits += [rBit()];
            }
            set result = ResultArrayAsInt(bits);

        } until (result <= max);

        return result;
    }
    // Generates random number
    // between 0 and max

    operation RandNum() : Int {
        let max = RandInRange(100);
        mutable result = 0;

        repeat {
            mutable bits = new Result[0];

            for (idxBit in 1..BitSizeI(max)) {
                set bits += [rBit()];
            }
            set result = ResultArrayAsInt(bits);

        } until (result <= max);

        return result;
    }
    // Generates a random number
    // between 0 and 100
}
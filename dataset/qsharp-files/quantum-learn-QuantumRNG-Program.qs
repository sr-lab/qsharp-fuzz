namespace QuantumRNG {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    operation GenerateRandomBit() : Result {
         // Allocate a qubit.
        use q = Qubit();
        // Put the qubit to superposition.
        H(q);
        // It now has a 50% chance of being measured 0 or 1.
        // Measure the qubit value.
        return M(q);
    }

    operation SampleRandomNumberInRange(min: Int, max : Int) : Int {
        mutable output = min; 
        repeat {
            mutable bits = new Result[0]; 
            for idxBit in 1..BitSizeI(max) {
                set bits += [GenerateRandomBit()]; 
            }
            set output = ResultArrayAsInt(bits);
        } until (output <= max and output >= min);
        return output;
    }

    operation SampleRandomHexString(size: Int) : String {
        mutable output = "";
        mutable actualSize = 0;
        repeat {
            let dec = SampleRandomNumberInRange(33, 122); // Between 33 and 122 we obtain ASCII characters valid for a password (symbols, letters and numbers)
            let charFromDecimal = IntAsStringWithFormat(dec, "X"); // Convert int to string (char)
            set output += charFromDecimal;
            set actualSize += 1;
        } until (actualSize == size);
        return output;
    }

    @EntryPoint()
    operation SampleRandomNumber() : Unit {
        let max = 50;
        let min = 10;
        let stringSize = 26;
        Message($"Sampling a random number between {min} and {max}: {SampleRandomNumberInRange(min, max)}");
        Message($"Sampling a random hex string of size {stringSize}: {SampleRandomHexString(stringSize)}");
    }
}

namespace quantum_random_number_generator {
    
    // imports
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    // Returns a random bit
    operation GenerateRandomBit() : Result {
        using(q = Qubit()) {
            // Put the qubit to superposition. It now has a 50% chance of being 0 or 1.
            H(q);
            // Measure the qubit value.
            return MResetZ(q);
        }
    }

    // Main logic function
    operation generate_random_number_in_range(max: Int) : Int {
        mutable output = 0;
        // similar to do while loop 
        repeat {
            // generate a new bit 
            mutable bits = new Result[0];
            
            // BitSizeI - for a non negative number returns the 
            // number of bits required to represent the numeber 
            for(idxBit in 1..BitSizeI(max))
            {
                // create an array of random bits generated
                set bits += [GenerateRandomBit()];
            }

            // convert that array of bits to an int
            set output = ResultArrayAsInt(bits);

            // compare if output is greater than max then re re run 
            // the whole code until output is less than or equal to max
        } until(output <= max);

        return output;
    }

    @EntryPoint()
    operation generate_random_number() : Int {
        let max = 50000;
        Message($"A random number between 0 and {max}: ");
        return generate_random_number_in_range(max);
    }
}

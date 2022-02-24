namespace Quantum.QuantumRNG {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    operation GenearateRandomBit(): Result{
    
        using(q = Qubit()){

            // Qubit to superposition.
			H(q);

            // Measure and reset qubit to zero state.
            return MResetZ(q);
		}

	}

    operation SampleRandomNumberInRange(min: Int, max: Int): Int{

        mutable output = 0;

        repeat{
        
            mutable bits = new Result[0];

            for(idxBits in 1..BitSizeI(max)){
                set bits += [GenearateRandomBit()];

                set output = ResultArrayAsInt(bits);
            
			}

		} until(output <= max and output >= min);

        return output;
	}

    @EntryPoint()
    operation SampleRandomNumber(): Int{
    
        let min = 21;
        let max = 50;

        Message($"Sampling random number in range [{min}...{max}]");

        return SampleRandomNumberInRange(min, max);
	}

}

namespace RandomNumberGenerator {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;


    operation GenerateRandomBit() : Result {

        using (q = Qubit()) {
            H(q);

            return MResetZ(q);
        }
    }


    operation GenerateRandomNumber(maxValue : Int) : Int {

        // Mutable Variables can change during computation
        mutable result = 0;

        repeat {

            mutable bits = new Result[0];

            for(idxBit in 1..BitSizeI(maxValue)) {
                set bits += [GenerateRandomBit()];
            }

            // Convert to positive Integer from string
            set result = ResultArrayAsInt(bits);

        } until (result <= maxValue);

        return result;

    }


    @EntryPoint()
    operation DisplayRandomNumberMessage() : Int {

        let maxValue = 100;

        Message($"Random Number between 0 and {maxValue} is: ");

        return GenerateRandomNumber(maxValue);
    }
}

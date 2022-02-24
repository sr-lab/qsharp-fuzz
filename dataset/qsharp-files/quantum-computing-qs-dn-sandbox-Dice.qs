namespace Dice {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;
    
    operation RandomBitGen(): Result {
        use q = Qubit();
        H(q);
        return MResetZ(q);
    }

    operation OneDice() : Int {
        mutable bits = new Result[0];
        for i in 1..3 {
            set bits += [RandomBitGen()];
        }
        return ResultArrayAsInt(bits);
    }

    operation MessageMultipleDice(count: Int) : Unit {
        for i in 1..count {
            let num = OneDice();
            Message(IntAsString(num));
        }
    }
}
namespace Quantum.Bell {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    operation Set(desired : Result, target : Qubit) : Unit {
        if (desired != M(target)) {
            X(target);
        }
    }
    
    operation TestBellState(count : Int, initial : Result) : (Int, Int, Int) {
        mutable numOnes = 0;
        mutable agree = 0;

        using ((q0, q1) = (Qubit(), Qubit())) {
            for (test in 1..count) {
                Set(initial, q0);
                Set(Zero, q1);

                H(q0);
                CNOT(q0, q1);

                let res = M(q0);

                if (res == M(q1)) {
                    set agree += 1;
                }

                if (res == One) {
                    set numOnes += 1;
                }
            }

            Set(Zero, q0);
            Set(Zero, q1);
        }

        return (count - numOnes, numOnes, agree);
    }
}


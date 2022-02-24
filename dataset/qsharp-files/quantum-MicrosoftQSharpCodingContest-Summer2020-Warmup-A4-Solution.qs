namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    operation Solve (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        using (qs = Qubit[2]) {
            unitary(qs);
            let res = M(qs[1]);
            ResetAll(qs);
            return res == Zero
                ? 1  // If it's Zero, then CNOT (because didn't flip, because q[0] is Zero).
                | 0;  // If it's One, then I(x)X (because flipped second one no matter the first).
        }
    }

    operation IxX(qs : Qubit[]) : Unit
    is Adj+Ctl {
        I(qs[0]);
        X(qs[1]);
    }

    operation CNOT_arr(qs : Qubit[]) : Unit
    is Adj+Ctl {
        CNOT(qs[0], qs[1]);
    }

    operation TestSolve(unitary : Int) : Int {
        return unitary == 0 ? Solve(IxX) | Solve(CNOT_arr);
    }
}

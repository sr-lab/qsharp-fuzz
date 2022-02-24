namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    operation Solve (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        using (qs = Qubit[2])
        {
            X(qs[1]);
            unitary(qs);
            let res = M(qs[0]);
            ResetAll(qs);
            return res == Zero ? 0 | 1;
        }
    }

    operation CNOT_12(qs: Qubit[]) : Unit is Adj+Ctl {
        CNOT(qs[0], qs[1]);
    }

    operation CNOT_21(qs: Qubit[]) : Unit is Adj+Ctl {
        CNOT(qs[1], qs[0]);
    }

    operation TestSolve(unitary : Int) : Int {
        return unitary == 0 ? Solve(CNOT_12) | Solve(CNOT_21);
    }
}

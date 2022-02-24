namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    operation Solve (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        using (qs = Qubit[2])
        {
            // Try |10>
            // IxI      -> |10>
            // CNOT_12  -> |11>
            // CNOT_21  -> |10>
            // SWAP     -> |01>
            X(qs[0]);
            unitary(qs);
            let res_0 = M(qs[0]);
            let res_1 = M(qs[1]);
            ResetAll(qs);

            // Try |11>
            // IxI      -> |11>
            // CNOT_12  -> |10>
            // CNOT_21  -> |01>
            // SWAP     -> |11>
            X(qs[0]);
            X(qs[1]);
            unitary(qs);
            let res_2 = M(qs[0]);
            let res_3 = M(qs[1]);
            ResetAll(qs);

            mutable ans = 0;
            if (res_0 == One and res_1 == Zero)
            {
                if (res_2 == One)
                {
                    set ans = 0;  // IxI
                }
                else
                {
                    set ans = 2;  // CNOT_21
                }
            }
            elif (res_0 == One and res_1 == One)
            {
                set ans = 1;  // CNOT_12
            }
            elif (res_0 == Zero)
            {
                set ans = 3;  // SWAP
            }
            return ans;
        }
    }

    operation IxI(qs: Qubit[]) : Unit is Adj+Ctl {
    }

    operation CNOT_12(qs: Qubit[]) : Unit is Adj+Ctl {
        CNOT(qs[0], qs[1]);
    }

    operation CNOT_21(qs: Qubit[]) : Unit is Adj+Ctl {
        CNOT(qs[1], qs[0]);
    }

    operation SWAP_OP(qs: Qubit[]) : Unit is Adj+Ctl {
        SWAP(qs[0], qs[1]);
    }

    operation TestSolve(unitary : Int) : Int {
        if (unitary == 0) {
            return Solve(IxI);
        }
        if (unitary == 1) {
            return Solve(CNOT_12);
        }
        if (unitary == 2) {
            return Solve(CNOT_21);
        }
        if (unitary == 3) {
            return Solve(SWAP_OP);
        }
        return -1;
    }
}

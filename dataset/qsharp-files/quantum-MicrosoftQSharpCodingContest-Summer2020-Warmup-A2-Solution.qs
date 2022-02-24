namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    operation Solve (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        using (q = Qubit()) {
            H(q);
            unitary(q);
            H(q);
            let res = MResetZ(q);
            return res == Zero
                ? 0  // It was I gate.
                | 1;  // It was Z gate.
        }
    }

    operation TestSolve(unitary : Int) : Int {
        return unitary == 0 ? Solve(I) | Solve(Z);
    }
}

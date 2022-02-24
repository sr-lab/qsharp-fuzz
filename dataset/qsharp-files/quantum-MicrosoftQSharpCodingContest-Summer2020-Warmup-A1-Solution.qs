namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    operation Solve(unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        using (q = Qubit()) {
            unitary(q);
            let res = MResetZ(q);
            return res == One
                ? 1  // It was X gate.
                | 0;  // It was I gate.
        }
    }

    operation TestSolve(unitary : Int) : Int {
        return unitary == 0 ? Solve(I) | Solve(X);
    }
}

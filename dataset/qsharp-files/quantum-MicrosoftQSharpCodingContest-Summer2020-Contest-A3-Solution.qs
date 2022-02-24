namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    operation Solve(unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        using (q = Qubit())
        {
            // X (|0>) -> |1> -> Z(|1>) -> -|1> -> X(-|1>) -> -|0>
            // H (|0>) -> |+> -> Z(|+>) -> |-> -> H(|->) -> |1>
            unitary(q);
            Z(q);
            unitary(q);
            return MResetZ(q) == One ? 0 | 1;
        }
    }

    operation TestSolve(unitary : Int) : Int {
        return unitary == 0 ? Solve(H) | Solve(X);
    }
}

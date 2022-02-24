namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;

    operation Solve(unitary : ((Double, Qubit) => Unit is Adj+Ctl)) : Int {
        using (qs = Qubit[2])
        {
            H(qs[0]);
            Controlled unitary(qs[0..0], (PI() * 2.0, qs[1]));
            H(qs[0]);
            return MResetZ(qs[0]) == One ? 0 | 1;
        }
    }

    operation TestSolve(unitary : Int) : Int {
        return unitary == 0 ? Solve(Rz) | Solve(R1);
    }
}

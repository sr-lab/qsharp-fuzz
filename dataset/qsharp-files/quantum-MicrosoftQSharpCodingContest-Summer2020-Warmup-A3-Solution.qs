namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    operation Solve (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        using (q = Qubit()) {
            H(q);
            // Two rotations of Z would be I. So, H -> I -> H would be I.
            // Two rotations of S would be Z. So, H -> Z -> H would be X.
            unitary(q);
            unitary(q);
            H(q);
            let res = MResetZ(q);
            return res == Zero
                ? 0  // Z gate. 
                | 1;
        }
    }

    operation TestSolve(unitary : Int) : Int {
        return unitary == 0 ? Solve(Z) | Solve(S);
    }
}

namespace Quantum.QuantumSearch {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    operation FixedSearch() : Int {
        use (q1, q2) = (Qubit(), Qubit());

        H(q1);
        H(q2);

        CZ(q1, q2);
        DumpMachine();

        X(q1);
        H(q1);
        H(q2);
        X(q1);
        X(q2);
        CZ(q1, q2);
        X(q1);
        X(q2);
        H(q1);
        H(q2);

        let register = LittleEndian([q1, q2]);
        let number = MeasureInteger(register);
        return number;
    }

    //@EntryPoint()
    //operation Main() : Unit {
    //let result = FixedSearch();
    //Message($"Expected to find a fixed: 2, found: {result}");
    //}
}

namespace QuantumSearch {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;


    operation GenericSearch(numberToFind : Int) : Int {
        use qubits = Qubit[2];
 
        ApplyToEachA(H, qubits);

        CZ(qubits[0], qubits[1]);
 
        if (numberToFind == 1 or numberToFind == 0) {
            X(qubits[1]);
        }
        if (numberToFind == 2 or numberToFind == 0) {
            X(qubits[0]);
        }
 
        // invert about the mean
        ApplyToEachA(H, qubits);
        ApplyToEachA(X, qubits);
        CZ(qubits[0], qubits[1]);
        ApplyToEachA(X, qubits);
        ApplyToEachA(H, qubits);
 
        let register = LittleEndian(qubits);
        let number = MeasureInteger(register);
        return number;
    }

    //@EntryPoint()
    //operation Main() : Unit {
      //  for i in 0..3 {
        //    let found = GenericSearch(i);
          //  Message($"Expected to find: {i}, found: {found}");
        //}
    //}
}

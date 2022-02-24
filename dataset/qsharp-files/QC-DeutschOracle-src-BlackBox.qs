namespace DeutschOracle.src {
    open Microsoft.Quantum.Experimental.Native;

    // Constant-0 Operation.
    operation ConstantZero(input: Qubit, output: Qubit): Unit {
        // This function do nothing. This is the definition of constant zero.
    }

    // Constant-1 Operation.
    operation ConstantOne(input: Qubit, output: Qubit): Unit {
        X(output);
    }

    // Identity Operation
    operation Identity(input: Qubit, output: Qubit): Unit {
        CNOT(input, output);
    }

    // Negation Operation.
    operation Negation(input: Qubit, output: Qubit): Unit {
        CNOT(input, output);
        X(output);
    }
}
namespace DeutschOracle.src {

    open Microsoft.Quantum.Experimental.Native;

    operation IsBlackBoxConstant(backBox: ((Qubit, Qubit) => Unit)): Bool {
        mutable inputResult = Zero;
        mutable outputResult = Zero;

        // Allocate 2 Qubits
        use qubits = Qubit[2];

        // Label qubits as input and output.
        let input = qubits[0];
        let output = qubits[1];

        // Preprocessing
        X(input);
        X(output);
        H(input);
        H(output);

        // Send qbits into blackbox.
        backBox(input, output);

        // Post-processing
        H(input);
        H(output);

        // Measure both qubits
        set inputResult = M(input);
        set outputResult = M(output);

        // If inputResult is one, then blackbox is constant; if 0, is balanced.
        return inputResult == One;
    }

    operation IsConstantZeroConstant(): Bool {
        return IsBlackBoxConstant(ConstantZero);
    }

    operation IsConstantOneConstant(): Bool {
        return IsBlackBoxConstant(ConstantOne);
    }

    operation IsIdentityConstant(): Bool {
        return IsBlackBoxConstant(Identity);
    }

    operation IsNegationConstant(): Bool {
        return IsBlackBoxConstant(Negation);
    }
}
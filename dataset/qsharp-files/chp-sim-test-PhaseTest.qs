namespace ChpSimulator.Test {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    
    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseRotateXQubit () : Unit {
        use q = Qubit();
        StatePlus(q); //|+>
        S(q); //|i>
        AssertMeasurementProbability([PauliX], [q], One, 0.5, "Should be |i>", 1e-5 );
        Reset(q);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseRotateX2Qubit () : Unit {
        use q = Qubit();
        StateI(q);
        S(q); //|->
        AssertMeasurement([PauliX], [q], One, "Should be |->");
        Reset(q);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseRotateYQubit () : Unit {
        use q = Qubit();
        H(q); //|+>
        S(q); //|i>
        AssertMeasurement([PauliY], [q], Zero, "Should be |i>");
        Reset(q);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseRotateY2Qubit () : Unit {
        use q = Qubit();
        H(q); //|+>
        S(q); //|i>
        S(q); //|->
        AssertMeasurementProbability([PauliY], [q], One, 0.5, "Should be |i>", 1e-5 );
        Reset(q);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseRotateZQubit () : Unit {
        use q = Qubit();
        H(q); //|+>
        S(q); //|i>
        AssertMeasurementProbability([PauliZ], [q], One, 0.5, "Should be |i>", 1e-5 );
        Reset(q);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseRotateZ2Qubit () : Unit {
        use q = Qubit();
        H(q); //|+>
        S(q); //|i>
        S(q); //|->
        AssertMeasurementProbability([PauliZ], [q], One, 0.5, "Should be |->", 1e-5 );
        Reset(q);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseZeroQubit () : Unit {
        use q = Qubit();
        S(q); //|0>
        AssertMeasurement([PauliZ], [q], Zero, "S gate can't move |0>");
        Reset(q);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseOneQubit () : Unit {
        use q = Qubit();
        X(q); //|1>
        S(q); //|1>
        AssertMeasurement([PauliZ], [q], One, "S gate can't move |1>");
        Reset(q);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseRotateMultiQubit () : Unit {
        use register = Qubit[3];
        H(register[1]); //|+>
        S(register[1]); //|i>

        AssertMeasurement([PauliZ],[register[0]], Zero, "Should be untouched");
        AssertMeasurementProbability([PauliZ], [register[1]], One, 0.5, "Should be |i>", 1e-5 );
        AssertMeasurement([PauliZ],[register[2]], Zero, "Should be untouched");
        Reset(register[1]);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseRotateXMultiQubit () : Unit {
        use register = Qubit[3];
        H(register[1]); //|+>
        S(register[1]); //|i>

        AssertMeasurementProbability([PauliX], [register[0]], One, 0.5, "Should be |0>", 1e-5 );
        AssertMeasurementProbability([PauliX], [register[1]], One, 0.5, "Should be |i>", 1e-5 );
        AssertMeasurementProbability([PauliX], [register[2]], One, 0.5, "Should be |0>", 1e-5 );
        Reset(register[1]);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseRotateYMultiQubit () : Unit {
        use register = Qubit[3];
        H(register[1]); //|+>
        S(register[1]); //|i>

        AssertMeasurementProbability([PauliY], [register[0]], One, 0.5, "Should be |0>", 1e-5 );
        AssertMeasurement([PauliY],[register[1]], Zero, "Should be |i>");
        AssertMeasurementProbability([PauliY], [register[2]], One, 0.5, "Should be |0>", 1e-5 );
        Reset(register[1]);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseRotatePairYMultiQubit () : Unit {
        use (left,right) = (Qubit(),Qubit());
        H(right); //|+>
        S(right); //|i>
        S(right); //|->
        AssertMeasurement([PauliZ],[left], Zero, "Should be untouched");
        AssertMeasurementProbability([PauliY], [right], One, 0.5, "Should be |->", 1e-5 );
        Reset(right);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseRotatePairXMultiQubit () : Unit {
        use (left,right) = (Qubit(),Qubit());
        H(right); //|+>
        S(right); //|i>
        S(right); //|->
        AssertMeasurement([PauliX], [right], One, "Should be |->");
        AssertMeasurementProbability([PauliX], [left], One, 0.5, "Should be untouched", 1e-5 );
        Reset(right);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseRotatePairZMultiQubit () : Unit {
        use (left,right) = (Qubit(),Qubit());
        H(right); //|+>
        S(right); //|i>
        S(right); //|->
        AssertMeasurement([PauliZ],[left], Zero, "Should be untouched");
        AssertMeasurementProbability([PauliZ], [right], One, 0.5, "Should be |->", 1e-5 );
        Reset(right);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseMultiQubit () : Unit {
        use register = Qubit[3];
        S(register[1]); //|0>
        AssertAllZero(register);
        Message("Test passed.");
    }

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation PhaseXMultiQubit () : Unit {
        use register = Qubit[3];
        X(register[1]); //|1>
        S(register[1]); //|1>

        AssertMeasurement([PauliZ],[register[0]], Zero, "Should be untouched");
        AssertMeasurement([PauliZ],[register[1]], One, "Qubit shouldn't have been flipped");        
        AssertMeasurement([PauliZ],[register[2]], Zero, "Should be untouched");
        ResetAll(register);
        Message("Test passed.");
    }
}

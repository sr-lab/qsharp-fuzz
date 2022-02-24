namespace ChpSimulator.Test {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;

    @Test("QSharpCommunity.Simulators.Chp.StabilizerSimulator")
    @Test("QuantumSimulator")
    operation MeasurementAndMessageTest() : Unit {
        use q = Qubit();
        H(q);
        let r = M(q);
        if (r == Zero) {
            Dog();
        }
        else
        {
            Duck();
        }
        Reset(q);
        Message("Test passed.");
    }

    operation Dog() : Unit 
    { 
        Message("Woof!!"); 
    }

    operation Duck() : Unit 
    { 
        Message("Quack!!"); 
    }
}

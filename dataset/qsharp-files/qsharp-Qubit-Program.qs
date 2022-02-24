// Qubit measurement in a Quantum Q# Language
// Author: Arthur Eugenio Silverio
// Data: 13/08/2021
// (C) 2021 Arthur Eugenio Silverio
// This file is released under the Simplified BSD License (see LICENSE)

namespace Quantum.Qyubit {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;

    @EntryPoint()
    operation Start() : Unit {
        // Start the measurements first for simple single qubit measurement for test
        use q = Qubit(); // cosider that state: |𝜓❭ = 0.6 |0❭ + 0.8 |1❭
        Ry(2.0 * ArcTan2(0.6, 0.8), q);
        Message("Qubit in state |𝜓❭:");
        DumpMachine();
        Message("Measuring the qubit at Pauli Z-basis...");
        let state = (M(q) == One ? 1 | 0);
        Message($"The measurement state is {state}.");
        Message($"Qubit measure: {state}. Post-measurement state:");
        DumpMachine();
        //Reset(q);

        // Measurement using M()
        Message("\nMeasurement using M()");
        MeasureQubits(1000);

        // Measurement using Pauli Basis
        Message("\nMeasurement using Pauli Basis: ");
        Message("PauliZ:"); // measurement in Z basis should produce 0 result 100% of time 
        MeasureQubitsPauli(1000, PauliZ);

        Message("\nPauliX:"); // measurement in X basis should produce 0 result 50% of time and 1 result the other 50% of time
        MeasureQubitsPauli(1000, PauliX);

        Message("\nPauliY:"); // measurement in Y basis should produce 0 result 50% of time and 1 result the other 50% of time
        MeasureQubitsPauli(1000, PauliY);
    }

    operation MeasureQubitsPauli(count : Int, measurementBasis : Pauli) : Unit
    {
        mutable ones = 0;
        Message("Starting Measure Qubits Pauli-Basis!!");
        Message("Measuring qubits " + IntAsString(count) + " times");

        use qubit = Qubit();
        for i in 0..count
        {
            let result = Measure([measurementBasis], [qubit]);
            set ones += result == One ? 1 | 0;
            Reset(qubit);
        }

        Message($"Received " + IntAsString(ones) + " ones.");
        Message($"Received " + IntAsString(count - ones) + " zeros.");
    }

    operation MeasureQubits(count : Int) : Unit
    {
        mutable ones = 0;
        Message("Starting Measure Qubits M() (Pauli Z-basis)!!");
        Message("Measuring qubits " + IntAsString(count) + " times");

        use qubit = Qubit();
        for i in 0..count
        {
            Ry(2.0 * ArcTan2(0.8, 0.6), qubit); // |𝜓❭ = 0.6 |0❭ + 0.8 |1❭
            set ones += M(qubit) == One ? 1 | 0;
            Reset(qubit);
        }
    
        Message("Received " + IntAsString(ones) + " ones.");
        Message("The theoretical probability of measuring 1 is 0.64.");
        Message("Received " + IntAsString(count - ones) + " ones.");
        Message("The theoretical probability of measuring 0 is 0.36.");
    }
}

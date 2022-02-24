namespace GraphColoringProblem {
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    

    operation SolveGraphColoringProblem() : Unit {
        // Number of Verticles
        let nVerticles = 5;

        let edges = [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3), (3, 4)];

        let coloring = [false, false, true, false, false, true, true, true, true, false];
        let colors = ["red", "green", "blue", "yellow"];

        let colorBits = Chunks(2, coloring);

        for(i in 0 .. nVerticles - 1) {

            let colorIndex = BoolArrayAsInt(colorBits[i]);
            Message($"Vertex {i} - color #{colorIndex} ({colors[colorIndex]})");

        }
    }

    operation MarkColorEquality(c0 : Qubit[], c1 : Qubit[], target : Qubit) : Unit is Adj+Ctl{

        within {

            for ((q0, q1) in Zipped(c0, c1)) {

                // XOR
                CNOT(q0, q1);
            }

        } apply {

            // Flip the target-state
            (ControlledOnInt(0, X))(c1, target);

        }

    }


    @EntryPoint()
    operation ShowColorEqualityCheck() : Unit {

        using ((c0, c1, target) = (Qubit[2], Qubit[2], Qubit())) {
        
            // Quantum-State of all possible colors on c1
            ApplyToEach(H, c1);

            Message("The initial state for qbit c1 and target:");
            DumpRegister((), c1 + [target]);

            // Compare registers and mark result in target qbit
            MarkColorEquality(c0, c1, target);

            Message("");
            Message("State of qbits after equality check:");
            DumpRegister((), c1 + [target]);

            // Return to |0⟩ before releasing
            ResetAll(c1 + [target]);

        }
    }
}

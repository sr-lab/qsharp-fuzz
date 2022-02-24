namespace QuantumHello {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Characterization;

    @EntryPoint()
    operation ZeroandBitString() : Unit {
        using (qs = Qubit[3]) {
            H(qs[0]);
            let bits = [true,true,true];
            for (i in 1..Length(bits)-1){
                if (bits[i]) {
                    CNOT(qs[0],qs[i]);
                }
            }
            DumpMachine();
            ResetAll(qs);
        }
    }
    

    operation BellState() : Unit {
        using (qs = Qubit[2]) {
            H(qs[0]);
            CNOT(qs[0],qs[1]);
            Message ("System State : ");
            DumpMachine();
            ResetAll(qs);
        }
    }

    operation CompoundGate() : Unit {
        using (qs = Qubit[3]) {
            S(qs[0]);
            H(qs[2]);
            Message ("System State : ");
            DumpMachine();
            ResetAll(qs);
        }
    }

    // Multi Qubit Systems Demo
    operation MultiQubitsystemDemo() : Unit {
        let divider = "-----------------------------------------";
        // Allocate an arrayof two Qubits, each of them in state |0⟩
        // The overall state of the system is |00⟩
        using (qs = Qubit[2]){
            // The X Gate changes the state of the first Qubit to |1⟩
            // The state of the entire system is |10⟩
            X(qs[0]);
            Message ("System in state |10⟩ |1⟩ : ");
            DumpMachine();
            Message (divider);

            // Change the second Qubit to state |+⟩
            H(qs[1]);
            Message ("System in state : ");
            DumpMachine();
            Message(divider);

            // Change state of first Qubit to |-⟩
            H(qs[0]);
            Message ("System in state : ");
            DumpMachine();
            Message (divider);

            // Examine state of first Qubit
            Message ("State of First Qubit : ");
            DumpMachine((),qs[0]);
            Message (divider);

            // Entangle the Qubits
            H(qs[1]);
            CNOT(qs[0],qs[1]);

            // Examine Entangled State
            Message ("Entangled State : ");
            DumpMachine();
            Message(divider);

            ResetAll(qs);
        }
    }

    // Qubits Demo
    operation QubitsDemo() : Unit {
        let divider = "-----------------------------------------";
        using (q = Qubit()) {
            Message("State |0⟩ :");
            // State of the quantum computer
            // Since only one qubit is allocated only it's state is printed
            DumpMachine();
            Message(divider);

            // Change the state of the qubit from |0⟩ to |1⟩
            X(q);
            Message("State |1⟩ :");
            DumpMachine();
            Message(divider);

            // Put the qubit into superposition
            H(q);
            Message("State |-⟩ :");
            DumpMachine();
            Message(divider);

            // Change the state of the qubit to |-i⟩
            S(q);
            Message("State |-i⟩ :");
            DumpMachine();
            Message(divider);

            // Put the Qubit in uneven superposition
            Rx(2.0,q);
            Ry(1.0,q);
            Message("Uneven Superposition");
            DumpMachine();
            Message(divider);

            // Return Qubit to state |0⟩
            Reset(q);
        }
        
    }
    
    // Exploring Grovers Search Algorithm
    operation MarkColorEquality(c0:Qubit[],c1:Qubit[],target:Qubit) : Unit is Adj+Ctl {
        within {
            //Iterate over pairs of qubits in matching positions in c0 and c1
            for ((q0,q1) in Zipped(c0,c1)) {
                // Compute XOR of c0 and c1 in place (storing it in q1)
                CNOT(q0,q1);
            }
        }
        apply {
            // If all computed XORs are 0, the bit strings are equal - flip the state of the target.
            (ControlledOnInt(0, X))(c1, target);
        }
    }

operation ApplyMarkingOracleAsPhaseOracle(
        markingOracle : ((Qubit[], Qubit[], Qubit) => Unit is Adj), 
        c0 : Qubit[],
        c1 : Qubit[]
    ) : Unit is Adj {
        using (target = Qubit()) {
            within {
                // Put the target qubit into the |-⟩ state.
                X(target);
                H(target);
            } apply {
                // Apply the marking oracle; since the target is in the |-⟩ state,
                // flipping the target if the register state satisfies the condition 
                // will apply a -1 relative phase to the register state.
                markingOracle(c0, c1, target);
            }
        }
    }


    //@EntryPoint()
    operation ShowPhaseKickbackTrick() : Unit {
        using ((c0, c1) = (Qubit[2], Qubit[2])) {
            // Leave register c0 in the |00⟩ state.

            // Prepare a quantum state that is a superposition of all possible colors on register c1.
            ApplyToEach(H, c1);

            // Output the initial state of qubits c1. 
            // We do not include the state of qubits in the register c0 for brevity, 
            // since they will remain |00⟩ throughout the program.
            Message("The starting state of qubits c1:");
            DumpRegister((), c1);

            // Compare registers and mark the result in their phase.
            ApplyMarkingOracleAsPhaseOracle(MarkColorEquality, c0, c1);

            Message("");
            Message("The state of qubits c1 after the equality check:");
            DumpRegister((), c1);

            // Return the qubits to |0⟩ state before releasing them.
            ResetAll(c1);
        }
    }

    operation MarkValidVertexColoring(
        edges : (Int, Int)[], 
        colorsRegister : Qubit[], 
        target : Qubit
    ) : Unit is Adj+Ctl {
        let nEdges = Length(edges);
        // Split the register that encodes the colors into an array of two-qubit registers, one per color.
        let colors = Chunks(2, colorsRegister);
        // Allocate one extra qubit per edge to mark the edges that connect vertices with the same color.
        using (conflictQubits = Qubit[nEdges]) {
            within {
                for (((start, end), conflictQubit) in Zipped(edges, conflictQubits)) {
                    // Check that the endpoints have different colors: apply MarkColorEquality operation; 
                    // if the colors are the same, the result will be 1, indicating a conflict.
                    MarkColorEquality(colors[start], colors[end], conflictQubit);
                }
            } apply {
                // If there are no conflicts (all qubits are in 0 state), the vertex coloring is valid.
                (ControlledOnInt(0, X))(conflictQubits, target);
            }
        }
    }

    //@EntryPoint()
    operation ShowColorValidationCheck() : Unit {
        let nVertices = 5;
        let edges = [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3), (3, 4)];
        let coloring = [false, false, true, false, false, true, true, true, false, true];
        using ((coloringRegister, target) = (Qubit[2 * nVertices], Qubit())) {
            ApplyPauliFromBitString(PauliX, true, coloring, coloringRegister);
            MarkValidVertexColoring(edges, coloringRegister, target);
            let isColoringValid = M(target) == One;
            Message($"The coloring is {isColoringValid ? "valid" | "invalid"}");
            ResetAll(coloringRegister);
        }
    }


    operation ShowColorEqualityCheck() : Unit {
        using ((c0,c1,target) = (Qubit[2],Qubit[2],Qubit())) {
            // Leave register c0 in the |00⟩ state
            // Prepare a quantum state that is a superposition of all possible colors on register c1
            ApplyToEach(H,c1);
            // Output the initial states of registers c1 and target
            Message ("The initial states of registers c1 and target : ");
            DumpRegister ((), c1 + [target]);
            // Compare registers and mark results in target qubit 
            MarkColorEquality(c0,c1,target);
            Message (" ");
            Message ("The state of the qubits c1 and target after equality check : ");
            DumpRegister((), c1+[target]);
            //Return Qubits to |0⟩ state before releasing
            ResetAll(c1+[target]);
        }
    }

    operation SolveGraphColoringProblem() : Unit {
        // The number of vertices is an integer
        let nVertices = 5;

        // Hard code the edges as tuples with start and end vertices
        let edges = [(0,1), (0,2), (0,3), (1,2), (1,3), (2,3), (3,4)];

        // Hardcoded Graph Coloring
        let coloring = [false, false, true, false, false, true, true, true, true, false];
        let colors = ["red", "green", "blue", "yellow"];

        // Interpret the coloring : Split the bit string into two bit fragments and convert them to colors
        let colorBits = Chunks(2, coloring);
        for (i in 0..nVertices-1) {
            let colorIndex = BoolArrayAsInt(colorBits[i]);
            Message ($"Vertex {i} - color #{colorIndex} ({colors[colorIndex]})");
        }


    }

    // Random Qubit
    operation GenerateRandomBit() : Result {
        using (q = Qubit()){
            // Put the qubit to superposition
            H(q);
            // The qubit now has an equal chance of being measured 0 or 1
            // Measure the qubit
            return MResetZ(q);
        }
    }

    operation SampleRandomNumberInRange(min : Int,max : Int) : Int {
        mutable output = 0;
        repeat{
            mutable bits = new Result [0];
            for (idxBit in 1..BitSizeI(max)){
                set bits += [GenerateRandomBit()];
            }
            set output = ResultArrayAsInt(bits);
        } until (output >= min and output <= max);
        return output;
    }

    operation SampleRandomNumber() : Int {
        // Minimum Value
        let min = 30;
        // Maximum Value
        let max = 40;
        Message ($"Sampling a Random Number between {min} and {max} : ");
        return SampleRandomNumberInRange(min,max);
    }

   
    operation GenerateRandomBitAgain() : Result {
        using (q = Qubit()) {
            Message ("Initial state of Qubit");
            DumpMachine();
            Message (" ");
            H(q);
            Message ("Applying Hadamard Gate to Qubit");
            DumpMachine();
            Message (" ");
            let randomBit = M(q);
            Message ("Measuring Qubit");
            DumpMachine();
            Message (" ");
            Reset(q);
            Message ("Resetting Qubit");
            DumpMachine();
            Message (" ");
            return randomBit;
        }
    }

    
    operation GenerateSpecificState(alpha : Double) : Result {
        using (q = Qubit()) {
            Ry(2.0 * ArcCos(Sqrt(alpha)),q);
            Message ("Qubit is in the desired state");
            Message (" ");
            DumpMachine();
            Message (" ");
            Message ("Your skewed Random Bit is");
            let skewed = M(q);
            Reset (q);
            return skewed;
        }
    }


    operation GenerateRandomNumber() : Int {
        using (qubits = Qubit[3]) {
            ApplyToEach(H, qubits);
            Message ("The qubit register in a uniform superposition: ");
            Message (" ");
            DumpMachine();
            let result = ForEach(MResetZ, qubits);
            //ForEach(Reset, qubits);
            Message ("Measuring collapses qubits to a basis state");
            Message (" ");
            DumpMachine();
            return BoolArrayAsInt(ResultArrayAsBoolArray(result));
        }
    }

    
    operation GenerateRandomNumberMulQubit() : Int{
        using (qubits = Qubit[3]) {
            ApplyToEach (H,qubits);
            Message ("The qubit register in uniform superposition: ");
            DumpMachine();
            Message (" ");
            mutable results = new Result[0];
            for (q in qubits) {
                Message (" ");
                set results += [M(q)];
                DumpMachine();
            }
            Message (" ");
            return BoolArrayAsInt(ResultArrayAsBoolArray(results));
        }
    }

// Exploring Interference
    
    operation TestInterference1() : Result {
        using (q = Qubit()) {
            Message ("At the beginning the qubit is in the state |0>");
            Message (" ");
            DumpMachine();
            H(q);
            Message ("After applying H the qubit is in uniform supoerposition");
            Message (" ");
            DumpMachine();
            H(q);
            Message ("If we reapply H the qubit returns to the state |0>");
            Message (" ");
            DumpMachine();
            Message ("If we measure we always obtain |0>");
            Message (" ");
            return MResetZ(q);
        }
    }

    
    operation TestInterference2() : Unit{
        using (q = Qubit()) {
            X(q);
            H(q);
            DumpMachine();
            Reset(q);
        }
    }

    
    operation TestInterference3() : Unit {
        using (q = Qubit()) {
            Y(q);
            H(q);
            DumpMachine();
            Reset(q);
        }
    }

    // Exploring Entanglement

    operation TestingEntanglement1() : Result[] {
        using (qubits = Qubit[2]) {
            H(qubits[0]);
            CNOT (qubits[0],qubits[1]);
            Message ("Entangled state before measurement");
            DumpMachine();
            Message (" ");
            let result = MultiM(qubits);
            Message ("State after measurement");
            DumpMachine();
            return result;
        }

    }

    
    operation TestingEntanglement2() : Result[] {
        using (qubits = Qubit[2]) {
            H(qubits[0]);
            Controlled X ([qubits[0]],qubits[1]);
            Message ("Entangled state before measurement");
            DumpMachine();
            Message (" ");
            let results = MultiM(qubits);
            Message ("State after measurement");
            DumpMachine();
            return results;
        }
    }

}

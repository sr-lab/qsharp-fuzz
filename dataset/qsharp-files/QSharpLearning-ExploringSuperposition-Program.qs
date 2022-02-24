namespace Quantum.ExploringSuperposition {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;

    operation GenerateRandomBit(): Result{
    
        using(q = Qubit()){

            Message("Init:");
            DumpMachine();
            Message(" ");

            H(q);
            Message("H applied:");
            DumpMachine();
            Message(" ");

            let result = M(q);
            Message("After Measure:");
            DumpMachine();
            Message(" ");

            Reset(q);
            Message("After Reset:");
            DumpMachine();
            Message(" ");

            return result;
        
		}

	}

    operation GenerateSpecificState(alpha: Double): Result {
    
        using(q = Qubit()){
      
            Ry(2.0*ArcCos(Sqrt(alpha)), q);

            Message("Init:");
            DumpMachine();
            Message(" ");

            return M(q);

		}


	}

    operation Main(): Unit{
    
        let result = GenerateSpecificState(0.333333);
        Message($"Measure result: {result}");


	}

    operation GenerateRandomNumber(): Int {
    
        using(qubits = Qubit[3]){
        
            ApplyToEach(H, qubits);
            Message("Qubit register in superposition:");
            DumpMachine();

            let results = ForEach(M, qubits);
            Message("Measure result:");
            DumpMachine();

            return BoolArrayAsInt( ResultArrayAsBoolArray(results));
		}

	}

     @EntryPoint()
    operation GenerateUniformState(): Int {
    
        using(qubits = Qubit[3]){
        
            ApplyToEach(H, qubits);
            Message("Qubit register in superposition:");
            DumpMachine();

            mutable results = new Result[0];

            for(q in qubits){

                Message(" ");
                set results += [M(q)];
                DumpMachine();
            
			}


            return BoolArrayAsInt( ResultArrayAsBoolArray(results));
		}

	}
}

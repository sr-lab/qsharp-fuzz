namespace qsharp_zne {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Characterization;

    @EntryPoint()
    operation RunZNE(scaleFactor : Int, numQubits : Int) : Double {
        let initialOperation = ApplyToEachCA(H,_);
        let oracle = CalculateExpectedValue(initialOperation, _, numQubits);
        let results = ForEach(oracle, [1, 2, 3, 4, 5]);
        //Implement classical data fitting with Nelder Meed?
        //1. Pick a model - exponential?
        //2. "Fit" that model to the results, return model parameters
        // a. Need Oracle that takes model and data and calculates the residuals
        // b. Implement function for NM method that actually takes oracle and returns optimal parameters
        //3. Evaluate the model at scale factor = 0 to find the ZNE result!

        return 0.0;
    }

    operation CalculateExpectedValue(
        op: (Qubit[] => Unit is Adj), scaleFactor : Int, numQubits : Int) 
    : Double {
        return EstimateFrequency(GlobalFold(op, scaleFactor), 
            Measure((ConstantArray(numQubits, PauliI) w/ 0 <- PauliZ),_), numQubits, 10);
    }

    operation ApplyTest(target : Qubit[]) : Unit
    is Adj + Ctl {
        //X(target[0]);
        H(target[0]);
        //DumpMachine(); TODO: Not working in current alpha
    }


    function GlobalFold(op : (Qubit[]=>Unit is Adj), scaleFactor : Int) 
    : (Qubit[]=>Unit is Adj) {
        //Figuring out how many "pairs" of operations to repeat
        let numPairs = (scaleFactor - 1) / 2;

        //[op, adj op, op, adj op,...]
        let foldedOperationArray = [op] + Flattened(ConstantArray(numPairs, [op, Adjoint(op)]));

        return (BoundA(foldedOperationArray));
        //return RepeatA(op, scaleFactor, _);
    }



}


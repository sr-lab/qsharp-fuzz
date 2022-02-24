namespace Quantum.QSharpPOC {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    /// # Summary
    /// 
    /// # Input
    /// ## count
    /// 
    
    operation EntryPoint(count : Int) : (Result, Result)
    {
        //Message("Hello quantum world!");
        using (input = Qubit()) 
        {
            H(input);
            let result_output = MeasureQubit(input); 
            
            let result_input = M(input);
            if (result_input == One) { X(input); }
            
            return (result_input, result_output);
        }
    }

    operation MeasureQubit(input: Qubit) : Result// (input : Qubit[], count : Int) : Qubit[]
    {
        using(output = Qubit())
        {
            CNOT(input,output);
            
            let result_output = M(output);

            if (result_output == One) { X(output); }
            // Finally, return the result of the measurement.
            return result_output;
        }
    }
}
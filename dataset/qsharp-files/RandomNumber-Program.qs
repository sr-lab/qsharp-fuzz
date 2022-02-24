namespace QuantumRNG {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    
    //operation SayHello() : Unit {
    //    Message("Hello quantum world!");
    //}
    operation GenerateRandomBit() : Result {
        // Allocate a qubit.
        use q = Qubit() {
            // Put the qubit to superposition.
            H(q);
            // It now has a 50% chance of being measured 0 or 1.
            // Measure the qubit value.
            return MResetZ(q);  
        }
    }

//Recall that we need to calculate the number of bits we need to express integers up to max. 
//The Microsoft.Quantum.Math library provides the BitSizeI function to accomplish this task.

//The SampleRandomNumberInRange operation uses a repeat loop to generate random numbers until it generates one that's equal 
//to or less than max.

//The for loop inside repeat works exactly the same as a for loop in other programming languages.

//In this example, output and bits are mutable variables. A mutable variable is one that can change during the computation. 
//You use the set directive to change a mutable variable's value.

//The ResultArrayAsInt function comes from the Microsoft.Quantum.Convert library. 
//This function converts the bit string to a positive integer.
    
    operation SampleRandomNumberInRange(max : Int,min : Int) : Int {
        mutable output = 0; 
        repeat {
            mutable bits = new Result[0]; 
            for idxBit in 1..BitSizeI(max) {
                set bits += [GenerateRandomBit()]; 
            }
            set output = ResultArrayAsInt(bits);
        } until (output <= max and output >= min);
        return output;
    }

//The let directive declares variables that don't change during the computation
//Bonus exercise
//Modify the program to also require the generated random number to be greater than some minimum number, min, instead of zero
    @EntryPoint()
    operation SampleRandomNumber() : Int {
        let max = 50;
        let min = 10;
        Message($"Sampling a random number between {min} and {max}: ");
        return SampleRandomNumberInRange(max,min);
    }

}


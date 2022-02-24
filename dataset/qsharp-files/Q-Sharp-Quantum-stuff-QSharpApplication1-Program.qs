namespace Quantum.QSharpApplication1 {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;

    operation SampleQuantumRandomNumberGenerator() : Result {
        using (q = Qubit()) {
            H(q);
            return MResetZ(q);
        }
    }

    operation SampleRandomNumberInRange(max : Int) : Int {
        mutable bits = new Result[0];
        for (idxBit in 1..BitSizeI(max)) {
            set bits += [SampleQuantumRandomNumberGenerator()];
        }
        let sample = ResultArrayAsInt(bits);
        return sample > max
            ? SampleRandomNumberInRange(max)
            | sample;
    }
    
    //@EntryPoint()
    operation GetGHX() : Unit {
        using(bits = Qubit[3]) {
            Message("Initial state |000>:");
            DumpMachine();
            // getting to GHZ init state:
            X(bits[2]);
            H(bits[2]);
            CNOT(bits[2], bits[0]);
            CNOT(bits[2], bits[1]);
            // now have eq 6.28, putting through next eq 6.27:
            X(bits[2]);
            H(bits[2]);
            CNOT(bits[2], bits[1]);
            Message("Altered state:");
            DumpMachine();
            
        }
    }

    operation Deutsch_Uf(bits : Qubit[]) : Unit {
        //X(bits[0]);
        //CNOT(bits[1],bits[0]); // other choices of Uf this is just 1 of 4
        X(bits[0]);
        //return bits;
    }

    @EntryPoint()
    operation Deutsch() : Result {
        using(bits = Qubit[2]) {
            // set up the operation:
            // structure: U_f(|x>|y>) = |x>|y+f(x)> i.e. |1st>|0th> the [0] bit is the output, [1] is the input
            X(bits[0]);
            X(bits[1]);
            H(bits[0]);
            H(bits[1]);
            // apply U_f:
            Deutsch_Uf(bits);
            H(bits[1]);
            // now ready to return
            let res = MResetZ(bits[1]);
            Reset(bits[0]); // need to reset all qubits at end so just toss the other register...
            return res;
            // indeed get the [1] bit i.e. the input register = 1 iff f(1) = f(0) i.e. the action of U_f
        }
    }

    //@EntryPoint()
    operation ProblemFourArbitraryRot() : Unit {
        // U(x/pi/4)U(z/pi/4)
        // do 643 times to get accuracy for 2pi/6 rot... do 6 times expect to get back to start?
        let accuracy = 20;
        using(bit = Qubit()) {
            for (i in 1..2..accuracy) {
                T(bit);
                H(bit);
                T(bit);
                H(bit);
            }
        DumpMachine(); // hits an error since we are repeating the operations too many times or something...
        }
    }
    
    operation SampleRandomNumber() : Int {
        let max = 50;
        Message($"Sampling a random number between 0 and {max}: ");
        return SampleRandomNumberInRange(max);
    }

    //@EntryPoint()
    operation HelloQ () : Unit {
        Message("Hello quantum world!");
    }
}

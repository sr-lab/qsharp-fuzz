namespace Quantum.Bell
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Set (desired: Result, q1: Qubit) : ()
    {
        body
        {
            let current = M(q1);

            if(desired != current)
            {
                X(q1);
            }

        }
    }


    operation BellTest (count: Int, initial: Result) : (Int, Int, Int)
    {
        body
        {
            mutable numOnes = 0;
            mutable agree = 0;

            // Get 2 Qubits to work with
            using(qubits = Qubit[2])
            {
                for (test in 1..count)
                {
                    // Set qubit0 to be the initial value provided (e.g. One)
                    Set (initial, qubits[0]);
                    // Set qubit1 to be an initial value of Zerp
                    Set(Zero, qubits[1]);

                    // Put qubit0 into a state of Superposition
                    H(qubits[0]);
                    
                    // Create entanglement between qubit0 and qubit1
                    CNOT(qubits[0],qubits[1]);

                    // Measure qubit0
                    let res = M(qubits[0]);

                    // Look if qubit1 == the result from looking at qubit0
                    // Becase we created entanglement, this will be true 100% of the times
                    // Both qubits will have the same value
                    if(M(qubits[1]) == res)
                    {
                        set agree = agree + 1;
                    }

                    // count the number of ones we saw
                    if (res == One)
                    {
                        set numOnes = numOnes + 1;
                    }

                }

                // Required by the USING statement, we must reset the qubits once we are done with them
                Set(Zero, qubits[0]);
                Set(Zero, qubits[1]);
            }

            // Return number of times we saw a |0> and number of times we saw a |1>
            return (count - numOnes, numOnes, agree);
        }
    }
}

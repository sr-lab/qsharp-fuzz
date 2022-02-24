namespace DeutschJoszaAlgorithm {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    
    operation bal(x : Qubit[], y : Qubit) : Unit {
            
        body(...) {
            for(q in x) {
                CNOT(q, y);
            }
                
        }
    }

    operation cons(x:Qubit[], y:Qubit) : Unit {

        body(...) {
            
        }
    }
    /// #Summary
    /// Operation implements Deutsch-Jozsa Algorithm
    /// Returns true if constant function and false if balanced
    operation Solve(N : Int, Uf : ((Qubit[], Qubit) => Unit)) : Bool {
        
        body(...) {
            using(qubits = Qubit[N+1]) {
                X(qubits[N]);
                ApplyToEach(H, qubits);

                Uf(qubits[0..N-1], qubits[N]);

                ApplyToEach(H, qubits[0..N-1]);

                mutable flag = 1;

                for(q in qubits[0..N-1]) {
                    if(M(q) == One) {
                        set flag = 0;
                    }
                }

                ResetAll(qubits);

                if(flag == 0) {
                    return false;
                }
                else {
                    return true;
                }
            }
        }
    }

    @EntryPoint()
    operation start() : Unit {
        let value = Solve(3, bal);
        Message($"{value}");
    }

}
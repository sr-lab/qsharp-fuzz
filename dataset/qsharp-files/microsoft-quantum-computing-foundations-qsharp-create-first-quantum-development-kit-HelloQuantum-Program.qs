namespace HelloQuantum {

    open Microsoft.Quantum.Intrinsic;    

    @EntryPoint()
    operation HelloQ() : Unit {
        Message("Hello quantum world!");
        
        // Allocate a qubit.
        using (q = Qubit()) {
            // Do something with q here.
        }
        
    }

}

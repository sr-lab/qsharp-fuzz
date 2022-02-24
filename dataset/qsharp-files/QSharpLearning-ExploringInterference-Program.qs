namespace Quantum.ExploringInterference {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;

    
    operation TestInterference1 () : Unit {
        
        using(q = Qubit()){
        
            // Initital state.
            Message(" ");
            Message("Start state |0>");
            DumpMachine();

            // Hadamar gate.
            H(q);
            Message(" ");
            Message("Apply H(q)");
            DumpMachine();

            // One more Hadamar gate.
            H(q);
            Message(" ");
            Message("Apply one more H(q)");
            DumpMachine();

            Reset(q);
		}

    }

    operation TestInterference2(): Unit{

        using(q = Qubit()){

            Message("");
            Message("Initial state:");
            DumpMachine();

            Message("");
            Message("X(q)");
            X(q);
            DumpMachine();

            Message("");
            Message("Hadamar gate");
            H(q);
            DumpMachine();


            Reset(q);



        }

    }

    @EntryPoint()
    operation TestInterference3(): Unit{

        using(q = Qubit()){

            Message("");
            Message("Initial state:");
            DumpMachine();

            Message("");
            Message("Y(q)");
            Y(q);
            DumpMachine();

            Message("");
            Message("Hadamar gate");
            H(q);
            DumpMachine();


            Reset(q);



        }

    }


}

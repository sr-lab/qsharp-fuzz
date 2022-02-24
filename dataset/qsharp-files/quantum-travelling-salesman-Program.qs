namespace TravellingSalesman {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    //Quantensuche 


    @EntryPoint()
    operation SayHello() : Unit {
        let costMatrix = [("Canakkale", 0, [0, 3, 1, 0, 0] ),
                         ("Hagen", 1, [3, 0, 2, 0, 2]),
                         ("Osnabrück", 2, [1, 2, 0, 3, 0]),
                         ("Athens", 3, [0, 0, 3, 0, 2]),
                         ("Rome", 4, [0, 2, 0, 2, 0])];
        let (label, index, costArray) = costMatrix[0];



        Message(label);
    }    

}

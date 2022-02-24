namespace DeutschOracle.src {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    
    @EntryPoint()
    operation driver() : Unit {
        let constantZeroConstant = IsConstantZeroConstant();
        Message($"Constant-0 Constant? {constantZeroConstant}");
    }
}

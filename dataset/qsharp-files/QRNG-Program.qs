namespace QRNG {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    

    @EntryPoint()
    operation SayHello() : Unit {
        let intVal = RandInt();
        Message($"Random int: {intVal}");
        let intInRange = RandIntInRange(100);
        Message($"Random int up to 100: {intInRange}");
    }

    operation RandInt() : Int {
        mutable val = 0;
        mutable bVal = 1;
        for(index in 0 .. 30) {
            if(IsResultOne(CollapseQubit())) {
                set val = val + bVal;
            }
            set bVal = bVal * 2;
        }
        return val;
    }

    operation RandIntInRange(range : Int) : Int {
        mutable val = 0;
        mutable bVal = 1;
        for(index in 0 .. 30) {
            if(IsResultOne(CollapseQubit())) {
                set val = val + bVal;
                    if(val > range) {
                        return val % range;
                    }
            }
            set bVal = bVal * 2;
        }
        return val;
    }

    operation CollapseQubit() : Result {
        using (q = Qubit()) {
            H(q);
            return MResetZ(q);    
        }
    }
}

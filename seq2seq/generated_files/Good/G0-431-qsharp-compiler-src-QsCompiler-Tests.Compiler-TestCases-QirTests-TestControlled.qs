 namespace Microsoft.Quantum.Instructions{ open Microsoft.Quantum.Targeting; @TargetInstruction("k") operation PhysK (qb : Qubit, n : Int) : Unit { body intrinsic; } @TargetInstruction("ck") operation PhysCtrlK (ctrls : Qubit[], qb : Qubit, n : Int) : Unit { body intrinsic; } } namespace Microsoft.Quantum.Intrinsic{ open Microsoft.Quantum.Instructions; @Inline() operation K(qb : Qubit, n : Int) : Unit is Adj+Ctl { body (...) { PhysK(qb, n); } adjoint self; controlled (ctrls, ...) { PhysCtrlK(ctrls, qb, n); } } } namespace Microsoft.Quantum.Testing.QIR{ open Microsoft.Quantum.Intrinsic; @EntryPoint() operation TestControlled () : Bool { let k2 = K(_, 2); let ck2 = Controlled k2; let ck1 = K(_, _); for (i in 0..100) { using ((ctrls, qb) = (Qubit[2], Qubit())) { ck2(ctrls, qb); using (moreCtrls = Qubit[3]) { Controlled ck2(moreCtrls, (ctrls, qb)); Controlled ck1(ctrls, (qb, 1)); } if (M(qb) != Zero) { return false; } } } return true; } } 
 namespace Microsoft.Quantum.Testing.QIR { operation SelfAdjointIntrinsic() : Unit is Adj + Ctl { body intrinsic; adjoint self; } operation SelfAdjointOp() : Unit is Adj + Ctl { body (...) { } adjoint self; } @EntryPoint() operation TestDeclarations () : Unit { use q2 = Qubit[2] { Custom(qs); Controlled Adjoint SelfAdjointIntrinsic([q], ()); Adjoint SelfAdjointOp(); Controlled Adjoint SelfAdjointOp([q], ()); } } } 
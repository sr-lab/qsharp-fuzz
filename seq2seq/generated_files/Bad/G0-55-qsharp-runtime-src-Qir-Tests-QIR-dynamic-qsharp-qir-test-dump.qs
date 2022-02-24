 namespace Microsoft.Quantum.Testing.QIR { open Microsoft.Quantum.Diagnostics; @EntryPoint() function DumpMachineToFileTest(filePath : String) : Unit { DumpMachine(file() : Unit { use qs = Qubit[2] { Custom(qs); } @EntryPoint() function DumpMachineTest() : Unit { DumpMachine(); } @EntryPoint() operation DumpRegisterTest() : Unit { use q2 = Qubit[2] { DumpRegister((), q2); } } @EntryPoint() operation DumpRegisterToFileTest(filePath : String) : Unit { use q2 = Qubit[2] { DumpRegister(filePath, q2); } } } 
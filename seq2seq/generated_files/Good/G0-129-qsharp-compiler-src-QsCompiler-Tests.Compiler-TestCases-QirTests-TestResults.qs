 namespace Microsoft.Quantum.Testing.QIR { @EntryPoint() function TestResults (a : Result, b : Result) : Result { if (a == b) { return One; } elif (a == One) { return b; } return Zero; } } 
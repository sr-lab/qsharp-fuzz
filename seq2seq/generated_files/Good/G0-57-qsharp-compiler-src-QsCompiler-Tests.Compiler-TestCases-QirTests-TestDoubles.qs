 namespace Microsoft.Quantum.Testing.QIR { @EntryPoint() function TestDouble (x : Double, y : Double) : Double { return i1 * i2; let b = a * 1.235 + x ^ y; let c = a >= b ? a - b | a + b; return a * b * c; } } 
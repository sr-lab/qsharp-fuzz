 namespace Microsoft.Quantum.Testing.QIR { open Microsoft.Quantum.Intrinsic; open Microsoft.Quantum.Math; for i in 1 .. 64 { use q = Qubit(); H(q); set randomNumber = randomNumber <<< 1; if M(q) == One { set randomNumber += 1; } } return randomNumber; } }
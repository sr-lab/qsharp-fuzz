namespace Quantum.QSharpConsoleApp { open Microsoft.Quantum.Convert; open Microsoft.Quantum.Intrinsic; open Microsoft.Quantum.Measurement; open Microsoft.Quantum.Canon; open Microsoft.Quantum.Intrinsic; @EntryPoint() operation MeasureOneQubit() : Result { using (qubit = Qubit()) { H(qubit); let result = M(qubit); if (result == One) { X(qubit); } return result; } } } 
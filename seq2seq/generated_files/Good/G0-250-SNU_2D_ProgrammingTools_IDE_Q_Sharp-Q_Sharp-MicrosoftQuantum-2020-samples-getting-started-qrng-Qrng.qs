 namespace Qrng { open Microsoft.Quantum.Convert; open Microsoft.Quantum.Math; open Microsoft.Quantum.Measurement; open Microsoft.Quantum.Canon; open Microsoft.Quantum.Intrinsic; operation SampleQuantumRandomNumberGenerator() : Result { using (q = Qubit()) { H(q); return MResetZ(q); } } operation SampleRandomNumberInRange(min : Int, max : Int) : Int { mutable output = 0; for (idxBit in 1..BitSizeI(max)) { set bits += [SampleQuantumRandomNumberGenerator()]; } let sample = ResultArrayAsInt(bits); return sample > max ? SampleRandomNumberInRange(max) | sample; } @EntryPoint() operation SampleRandomNumber() : Int { let max = 50; Message($"Sampling a random number between 0 and {max}: "); return SampleRandomNumberInRange(max); } } 
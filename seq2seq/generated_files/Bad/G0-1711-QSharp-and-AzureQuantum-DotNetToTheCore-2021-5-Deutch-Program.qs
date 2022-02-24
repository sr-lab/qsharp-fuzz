namespace Deutch { open Microsoft.Quantum.Canon; open Microsoft.Quantum.Convert; open Microsoft.Quantum.Intrinsic; @EntryPoint() operation HelloQ() : Unit { let (result1A, result1B) = DeutschTestConstantZero(); Message( "Constant-0: " + BoolAsString(result1A) + ", " + BoolAsString(result1B)); let (result2A, result2B) = DeutschTestConstantOne(); Message( "Constant-1: " + BoolAsString(result2A) + ", " + BoolAsString(result2B)); let (result3A, result3B) = DeutschTestIdentity(); Message( "Identity: " + BoolAsString(result3A) + ", " + BoolAsString(result3B)); let (result4A, result4B) = DeutschTestNegation(); Message( "Negation: " + BoolAsString(result4A) + ", " + BoolAsString(result4B)); } operation ConstantZero (qOutput: Qubit, qInput: Qubit) : Unit { } operation ConstantOne (qOutput: Qubit, qInput: Qubit) : Unit { X(qOutput); } operation Identity (qOutput: Qubit, qInput: Qubit) : Unit { CNOT(qInput, qOutput); } operation Negation (qOutput: Qubit, qInput: Qubit) : Unit { CNOT(qInput, qOutput); X(qOutput); } operation Deutsch (blackbox: ((Qubit, Qubit) => Unit)) : (Bool, Bool) { mutable result = (false, false); use register = Qubit[2]; let qOutput = register[0]; let qInput = register[1]; X(qOutput); X(qInput); H(qOutput); H(qInput); blackbox(qOutput, qInput); H(qOutput); H(qInput); let bOutput = M(qOutput); let bInput = M(qInput); set result = (bInput == One, bOutput == One); Reset(qOutput); Reset(qInput); return result; } operation DeutschTestConstantZero() : (Bool, Bool) { return Deutsch(ConstantZero); } operation DeutschTestConstantOne() : (Bool, Bool) { return Deutsch(ConstantOne); } operation DeutschTestIdentity() : (Bool, Bool) { return Deutsch(Identity); } operation DeutschTestNegation() : (Bool, Bool) { return Deutsch(Negation); } }  Message($"Quantum win percentage: {IntAsDouble(quantumWinCount) / IntAsDouble(numberOfGames)}");} }
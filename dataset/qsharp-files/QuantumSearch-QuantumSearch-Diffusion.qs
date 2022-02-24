namespace Quantum.QuantumSearch {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Measurement;

    operation MarkDivisor (
        dividend : Int,
        divisorRegister : Qubit[],
        target : Qubit
    ) : Unit is Adj + Ctl {
        let size = BitSizeI(dividend);
        use dividendQubits = Qubit[size];
        use resultQubits = Qubit[size];

        let xs = LittleEndian(dividendQubits);
        let ys = LittleEndian(divisorRegister);
        let result = LittleEndian(resultQubits);

        within {
            ApplyXorInPlace(dividend, xs);
            DivideI(xs, ys, result);
            ApplyToEachA(X, xs!);
        } apply {
            Controlled X(xs!, target);
        }
    }

    operation MarkingOracleAsPhase(
        markingOracle : (Qubit[], Qubit) => Unit is Adj, 
        register : Qubit[]) : Unit is Adj
        {
            use target = Qubit();
            within {
                X(target);
                H(target);
            } apply {
                markingOracle(register, target);
            }
        }

    operation GroversSearch(register : Qubit[], phaseOracle : ((Qubit[]) => Unit is Adj), iterations : Int) : Unit {
        ApplyToEach(H, register);
        for _ in 1 .. iterations {
            phaseOracle(register);
            ReflectAboutUniform(register);
        }
    }

    operation ReflectAboutUniform(inputQubits : Qubit[]) : Unit {
        within {
            ApplyToEachA(H, inputQubits);
            ApplyToEachA(X, inputQubits);
        } apply {
            Controlled Z(Most(inputQubits), Tail(inputQubits));
        }
    }

    @EntryPoint()
    operation FactorizedGrovers(number : Int) : Unit {
        let markingOracle = MarkDivisor(number, _, _);
        let phaseOracle = MarkingOracleAsPhase(markingOracle, _);
        let size = BitSizeI(number);
        let nSolutions = 4;
        let nIterations = Round(PI() / 4.0 * Sqrt(IntAsDouble(size) / IntAsDouble(nSolutions)));

        use (register, output) = (Qubit[size], Qubit());
        mutable isCorrect = false;
        mutable answer = 0;

        repeat {
            GroversSearch(register, phaseOracle, nIterations);
            let res = MultiM(register);
            set answer = BoolArrayAsInt(ResultArrayAsBoolArray(res));
            // Check that if the result is a solution with the oracle.
            markingOracle(register, output);
            if MResetZ(output) == One and answer != 1 and answer != number {
                set isCorrect = true;
            }
            ResetAll(register);
        } until isCorrect;

        Message($"The number {answer} is a factor of {number}.");
    }
}

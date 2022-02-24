namespace QAlgorithmsTester.PhaseEstimatorTester
{
    open QAlgorithms.PhaseEstimator;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
	open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;

    operation ToFirst(qs : Qubit[], U : (Qubit => Unit is Ctl), nr : Int) : Unit is Ctl
    {
        for (i in 0..nr - 1)
        {
            U(qs[0]);
		}
	}

	@Test("QuantumSimulator")
    operation PhaseEstimatorTester() : Unit
    {
        // TODO: Add more sophisticated tests.
        using (q = Qubit())
        {
            X(q);
            EqualityFactI(EstimatePhase(ApplyMultipleTimes(ToFirst(_, T, 1), _, _), [q], 3), 1, "Wrong Phase for Gate T");
            EqualityFactI(EstimatePhase(ApplyMultipleTimes(ToFirst(_, T, 2), _, _), [q], 3), 2, "Wrong Phase for Gate T");
            EqualityFactI(EstimatePhase(ApplyMultipleTimes(ToFirst(_, T, 3), _, _), [q], 4), 6, "Wrong Phase for Gate T");
            X(q);
	    }
    }
}

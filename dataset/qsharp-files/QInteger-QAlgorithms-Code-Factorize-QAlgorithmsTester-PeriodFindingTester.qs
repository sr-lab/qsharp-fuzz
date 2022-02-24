namespace QAlgorithmsTester.PeriodFinderTester
{
    open Microsoft.Quantum.Convert;
    open QTypes.QInteger;
    open QAlgorithms.PeriodFinder;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
	open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;

    operation Inc(qs : Qubit[], k : Int, Mod : Int) : Unit is Ctl
    {
        AddModCQC(k % Mod, QIntR(qs), Mod);
	}

    function clInc(a: Int, k : Int, Mod : Int) : Int
    {
        return (a + k) % Mod;
	}

	@Test("QuantumSimulator")
    operation PeriodFindingIncrementTester () : Unit
    {
        for (Mod in 3..8)
        {
            for (i in 0..Mod - 1)
            {
                let p = FindPeriod(i, Inc(_, _, Mod), clInc(_, _, Mod), Mod, 20);
                EqualityFactI(p, Mod, "Wrong Period for Incrementing. Period != Mod for Mod = " + IntAsString(Mod) + " and Starting value = " + IntAsString(i));
			}
		}
    }

    operation Add(qs : Qubit[], b : Int, k : Int, Mod : Int) : Unit is Ctl
    {
        AddModCQC((b*k) % Mod, QIntR(qs), Mod);
	}

    function clAdd(a: Int, b : Int, k : Int, Mod : Int) : Int
    {
        return (a + b*k) % Mod;
	}

	@Test("QuantumSimulator")
    operation PeriodFindingAddTester () : Unit
    {
        for (Mod in 3..8)
        {
            for (b in 0..Mod - 1)
            {
                for (s in 0..Mod - 1)
                {
                    let p = FindPeriod(s, Add(_,b,  _, Mod), clAdd(_, b, _, Mod), Mod, 20);
                    EqualityFactI(p, Mod / GCD(Mod, b), "Wrong Period for Adding. " + IntAsString(s) + " + k*" + IntAsString(b) + " mod " + IntAsString(Mod) + ", Wrong period: " + IntAsString(p));
			    }
			}
		}
    }
}

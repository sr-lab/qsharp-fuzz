namespace QAlgorithms.PeriodFinder
{
    open Microsoft.Quantum.Convert;
    open QAlgorithms.PhaseEstimator;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open QTypes.QInteger;

    internal function SmallestPow2WithPowBiggerThan(ip : Int): Int
    {
        mutable rs = 1;
        mutable e = 0;
        while (rs <= ip)
        {
            set rs = rs * 2;
            set e = e + 1;
		}
        return e;
	}

    operation FindPeriod(Start : Int, kth_next : ((Qubit[], Int) => Unit is Ctl), cls : ((Int, Int) -> Int), Size : Int, MAXREP : Int) : Int
    {
        mutable res = 0;
        mutable rep = 0;
        let n = SmallestPow2WithPowBiggerThan(Size);
        let q = 2*n;
        using (qs = Qubit[n])
        {
            repeat
            {
                set rep = rep + 1;
                if (rep > MAXREP)
                {
                    fail "Too many repetitions. Last Result: " + IntAsString(res) + " for finding period in function of \"Size\" <= " + IntAsString(Size) + " with starting value " + IntAsString(Start);
				}

                CopyToQInt(Start, QIntR(qs));
                let tp = EstimatePhase(kth_next, qs, q);
                mutable tr = 0;
                set (tr, res) = ApproximateFraction(tp, FastPow(2, q), Size);
                ResetAll(qs);
			}
            until (cls(Start, res) == Start and res > 0);
	    }
        return res;
    }
}

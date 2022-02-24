namespace QAlgorithms.Shor
{
    open Microsoft.Quantum.Convert;
    open QTypes.QInteger;
    open QAlgorithms.PeriodFinder;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    internal function MulByPow(sv : Int, bs : Int, ex : Int, Mod : Int) : Int
    {
        return (sv*FastPowMod(bs, ex, Mod)) % Mod;
	}

    internal operation QMulByPow(A : Int, Mod : Int, trg : Qubit[], rep : Int) : Unit is Ctl
    {
        MulMod(FastPowMod(A, rep, Mod), QIntR(trg), Mod);
	}

    operation ShorOrderFinder(A : Int, Mod : Int) : Int
    {
        return FindPeriod(1, QMulByPow(A, Mod, _, _), MulByPow(_, A, _, Mod), Mod, 20);
    }
}

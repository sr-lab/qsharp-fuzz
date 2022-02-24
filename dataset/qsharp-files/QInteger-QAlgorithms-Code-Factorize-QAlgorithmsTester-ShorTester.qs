namespace QAlgorithmsTester.ShorTester
{
    open Microsoft.Quantum.Intrinsic;
    open QAlgorithms.Shor;
    open QTypes.QInteger;
	open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

	@Test("QuantumSimulator")
    operation ShorTest() : Unit
    {
        for (Mod in 5..9)
        {
            for (Base in 2..Mod - 1)
            {
                if (GCD(Base, Mod) == 1)
                {
                    let per = ShorOrderFinder(Base, Mod);
                    Fact(FastPowMod(Base, per, Mod) == 1, "Wrong result: base^result != 1, base = " + IntAsString(Base) + ", result = " + IntAsString(per) + ", mod=" + IntAsString(Mod));
                    for (j in 1..per - 1)
                    {
                        Contradiction(FastPowMod(Base, j, Mod) == 1, "Wrong Reuslt: Smaller number j with base^j == 1: base = " + IntAsString(Base) + ", result = " + IntAsString(per) + ", smaller result=" + IntAsString(j) + ", mod=" + IntAsString(Mod));
		            }
			    }
			}
		}
	}
}

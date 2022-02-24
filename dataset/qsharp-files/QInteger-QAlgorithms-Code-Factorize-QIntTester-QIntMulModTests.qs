namespace QIntTester.MulModTester
{
	open QTypes.QInteger;
	open Microsoft.Quantum.Diagnostics;
	open Microsoft.Quantum.Intrinsic;
	open Microsoft.Quantum.Math;
	open Microsoft.Quantum.Convert;

	@Test("QuantumSimulator")
	operation InverseChecker() : Unit
	{
		for (i in 1..511)
		{
			for (j in 1..i - 1)
			{
				if (GCD(i, j) == 1)
				{
					let iv = Inverse(j, i);
					Fact((j*iv) % i == 1, "Inverse does not multiply to one (" + IntAsString(j) + "^-1 != " + IntAsString(iv) + " Mod " + IntAsString(i) + ")");
				}
			}
		}
		Message("Test passed.");
	}
}

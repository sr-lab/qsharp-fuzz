namespace QIntTester.SigOpTester
{
	open QTypes.QInteger;
	open Microsoft.Quantum.Diagnostics;
	open Microsoft.Quantum.Intrinsic;
	open Microsoft.Quantum.Math;
	open Microsoft.Quantum.Convert;

	@Test("QuantumSimulator")
	operation AddTest() : Unit
	{
		for (i in 0..31)
		{
			for (j in 0..31)
			{
				using (qs = Qubit[10])
				{
					let a = QInt(5, qs[0..4]);
					let b = QInt(5, qs[5..9]);
					CopyToQInt(i, a);
					CopyToQInt(j, b);
					Add(a, b);
					let res = MeasureQInt(b);
					EqualityFactI(res, (i + j) % PowI(2, 5), "Addition returned wrong result: " + IntAsString(i) + " + " + IntAsString(j) + " = " + IntAsString((i + j) % PowI(2, 5)) + " expected, returned " + IntAsString(res));
					ResetAll(qs);
				}
			}
		}
		Message("Test passed.");
	}

	@Test("QuantumSimulator")
	operation AddCQTest() : Unit
	{
		for (i in 0..31)
		{
			for (j in 0..31)
			{
				using (qs = Qubit[5])
				{
					let b = QInt(5, qs[0..4]);
					CopyToQInt(j, b);
					AddCQ(i, b);
					let res = MeasureQInt(b);
					EqualityFactI(res, (i + j) % PowI(2, 5), "Addition returned wrong result: " + IntAsString(i) + " + " + IntAsString(j) + " = " + IntAsString((i + j) % PowI(2, 5)) + " expected, returned " + IntAsString(res));
					ResetAll(qs);
				}
			}
		}
		Message("Test passed.");
	}

	@Test("QuantumSimulator")
	operation AddModTest() : Unit
	{
		for (i in 0..7)
		{
			for (j in 0..7)
			{
				for (k in 1..7)
				{
					using (qs = Qubit[9])
					{
						let a = QInt(3, qs[0..2]);
						let b = QInt(3, qs[3..5]);
						let c = QInt(3, qs[6..8]);
						CopyToQInt(i % k, a);
						CopyToQInt(j % k, b);
						CopyToQInt(k, c);
						AddMod(a, b, c);
						let res = MeasureQInt(b);
						EqualityFactI(res, (i + j) % k, "Addition returned wrong result: (" + IntAsString(i) + " + " + IntAsString(j) + ") % " + IntAsString(k) + " = " + IntAsString((i + j) % k) + " expected, returned " + IntAsString(res));
						ResetAll(qs);
					}
				}
			}
		}
		Message("Test passed.");
	}

	@Test("QuantumSimulator")
	operation AddModQQCTest() : Unit
	{
		for (i in 0..7)
		{
			for (j in 0..7)
			{
				for (k in 1..7)
				{
					using (qs = Qubit[6])
					{
						let a = QInt(3, qs[0..2]);
						let b = QInt(3, qs[3..5]);
						CopyToQInt(i % k, a);
						CopyToQInt(j % k, b);
						AddModQQC(a, b, k);
						let res = MeasureQInt(b);
						EqualityFactI(res, (i + j) % k, "Addition returned wrong result: (" + IntAsString(i) + " + " + IntAsString(j) + ") % " + IntAsString(k) + " = " + IntAsString((i + j) % k) + " expected, returned " + IntAsString(res));
						ResetAll(qs);
					}
				}
			}
		}
		Message("Test passed.");
	}

	@Test("QuantumSimulator")
	operation AddModCQCTest() : Unit
	{
		for (i in 0..7)
		{
			for (j in 0..7)
			{
				for (k in 1..7)
				{
					using (qs = Qubit[3])
					{
						let b = QInt(3, qs[0..2]);
						CopyToQInt(j % k, b);
						AddModCQC(i % k, b, k);
						let res = MeasureQInt(b);
						EqualityFactI(res, (i + j) % k, "Addition returned wrong result: (" + IntAsString(i) + " + " + IntAsString(j) + ") % " + IntAsString(k) + " = " + IntAsString((i + j) % k) + " expected, returned " + IntAsString(res));
						ResetAll(qs);
					}
				}
			}
		}
		Message("Test passed.");
	}

	@Test("QuantumSimulator")
	operation AddModCQQTest() : Unit
	{
		for (i in 0..7)
		{
			for (j in 0..7)
			{
				for (k in 1..7)
				{
					using (qs = Qubit[6])
					{
						let b = QInt(3, qs[0..2]);
						let c = QInt(3, qs[3..5]);
						CopyToQInt(j % k, b);
						CopyToQInt(k, c);
						AddModCQQ(i % k, b, c);
						let res = MeasureQInt(b);
						EqualityFactI(res, (i + j) % k, "Addition returned wrong result: (" + IntAsString(i) + " + " + IntAsString(j) + ") % " + IntAsString(k) + " = " + IntAsString((i + j) % k) + " expected, returned " + IntAsString(res));
						ResetAll(qs);
					}
				}
			}
		}
		Message("Test passed.");
	}
	
	@Test("QuantumSimulator")
	operation MulModAddTester() : Unit
	{
		for (i in 0..7)
		{
			for (j in 0..7)
			{
				for (Mod in 1..7)
				{
					using (qr = Qubit[6])
					{
						let b = QIntVS(qr, 3, j % Mod);
						let trg = QIntR(qr[3..5]);
						MulModAdd(i, b, trg, Mod);
						let res = MeasureQInt(trg);
						EqualityFactI(res, (i * j) % Mod, "Returned wrong result (Expected (" + IntAsString(i) + " * " + IntAsString(j) + ") % " + IntAsString(Mod) + " = " + IntAsString((i * j) % Mod) + ", got " + IntAsString(res));
						ResetAll(qr);
					}
				}
			}
		}
		Message("Test passed.");
	}

	@Test("QuantumSimulator")
	operation MulModTester() : Unit
	{
		for (i in 0..7)
		{
			for (j in 0..7)
			{
				for (Mod in 1..7)
				{
					if (GCD(i, Mod) == 1)
					{
						using (qr = Qubit[3])
						{
							let trg = QIntV(qr, j % Mod);
							MulMod(i % Mod, trg, Mod);
							mutable res = MeasureQInt(trg);
							EqualityFactI(res, (i * j) % Mod, "Returned wrong result (Expected (" + IntAsString(i) + " * " + IntAsString(j) + ") % " + IntAsString(Mod) + " = " + IntAsString((i * j) % Mod) + ", got " + IntAsString(res));
							ResetAll(qr);
						}
					}
				}
			}
		}
		Message("Test passed.");
	}

	@Test("QuantumSimulator")
	operation ModExpTester() : Unit
	{
		for (i in 0..7)
		{
			for (j in 0..7)
			{
				for (Mod in 2..7)
				{
					if (GCD(i, Mod) == 1)
					{
						using (qr = Qubit[6])
						{
							let exp = QIntVS(qr, 3, j);
							let trg = QIntR(qr[3..5]);
							ModExp(i % Mod, exp, trg, Mod);
							let res = MeasureQInt(trg);
							mutable er = FastPowMod(i, j, Mod);
							let eq = "(" + IntAsString(i) + "^" + IntAsString(j) + ") % " + IntAsString(Mod) + " = " + IntAsString(er);
							EqualityFactI(res, er, "Wrong answer: Expected" + eq + ", got " + IntAsString(res));
							ResetAll(qr);
						}
					}
				}
			}
		}
		Message("Test passed.");
	}

	@Test("QuantumSimulator")
	operation SingleModExpTimer() : Unit
	{
		using (qr = Qubit[6])
		{
			let bs = 2;
			let ex = 3;
			let Mod = 3;
			let exp = QIntVS(qr, 3, ex);
			let trg = QIntR(qr[3..5]);
			ModExp(bs, exp, trg, Mod);
			let res = MeasureQInt(trg);
			let er = FastPowMod(bs, ex, Mod);
			let eq = "(" + IntAsString(bs) + "^" + IntAsString(ex) + ") % " + IntAsString(Mod) + " = " + IntAsString(er);
			EqualityFactI(res, er, "Wrong answer: Expected" + eq + ", got " + IntAsString(res));
			ResetAll(qr);
		}
		Message("Test passed.");
	}
}

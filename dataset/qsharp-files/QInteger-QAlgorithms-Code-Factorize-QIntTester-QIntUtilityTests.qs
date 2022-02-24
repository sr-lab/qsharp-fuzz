namespace QIntTester.UtilityTester
{
	open QTypes.QInteger;
	open Microsoft.Quantum.Diagnostics;
	open Microsoft.Quantum.Intrinsic;
	open Microsoft.Quantum.Math;
	open Microsoft.Quantum.Convert;

	@Test("QuantumSimulator")
	operation ResetTest() : Unit
	{
		using (qr = Qubit[8])
		{
			let qn = QInt(8, qr);
			for (i in qr)
			{
				H(i);
			}
			ResetQInt(qn);
		}
		
		Message("Test passed.");
	}
	
	@Test("QuantumSimulator")
	operation CopyTest() : Unit
	{
		for (i in 0..255)
		{
			let ar = IntAsBoolArray(i, 8);
			using (qr = Qubit[8])
			{
				let qn = QInt(8, qr);
				CopyToQInt(i, qn);
				for (j in 0..7)
				{
					AssertQubit(BoolAsResult(ar[j]), qn::Number[j]);
				}
				ResetAll(qr);
			}
		}
		
		Message("Test passed.");
	}

	@Test("QuantumSimulator")
	operation ReadTest() : Unit
	{
		for (i in 0..255)
		{
			using (qr = Qubit[8])
			{
				let ba = IntAsBoolArray(i, 8);
				let qn = QInt(8, qr);
				for (j in 0..7)
				{
					if (ba[j])
					{
						X(qr[j]);
					}
				}
				EqualityFactI(MeasureQInt(qn), i, "Wrong number returned");
				ResetAll(qr);
			}
		}
		Message("Test passed.");
	}

	@Test("QuantumSimulator")
	operation IncrementTest() : Unit
	{
		for (i in 0..255)
		{
			using (qr = Qubit[8])
			{
				let qn = QInt(8, qr);
				CopyToQInt(i, qn);
				Increment(qn);
				EqualityFactI(MeasureQInt(qn), (i + 1) % 256, "Wrong number returned");
			}
		}
		Message("Test passed.");
	}

	@Test("QuantumSimulator")
	operation DecrementTest() : Unit
	{
		for (i in 0..255)
		{
			using (qr = Qubit[8])
			{
				let qn = QInt(8, qr);
				CopyToQInt(i, qn);
				Decrement(qn);
				EqualityFactI(MeasureQInt(qn), (i + 255) % 256, "Wrong number returned");
			}
		}
		Message("Test passed.");
	}

	@Test("QuantumSimulator")
	operation IsZeroTest() : Unit
	{
		for (i in 0..511)
		{
			using (qr = Qubit[10])
			{
				let qn = QInt(9, qr[0..8]);
				CopyToQInt(i, qn);
				IsZeroQInt(qn, qr[9]);
				AssertQubit(BoolAsResult(i == 0), qr[9]);
				ResetAll(qr);
			}
		}
		Message("Test passed.");
	}

	@Test("QuantumSimulator")
	operation InitTest() : Unit
	{
		for (i in 0..511)
		{
			using (qr = Qubit[9])
			{
				mutable qn = QIntV(qr, i);
				EqualityFactI(MeasureQInt(qn), i, "Initializer V returned QInt in wrong state");
				ResetAll(qr);
				set qn = QIntVS(qr, 9, i);
				EqualityFactI(MeasureQInt(qn), i, "Initializer VS returned QInt in wrong state");
				ResetAll(qr);
			}
		}
		Message("Test passed.");
	}
}

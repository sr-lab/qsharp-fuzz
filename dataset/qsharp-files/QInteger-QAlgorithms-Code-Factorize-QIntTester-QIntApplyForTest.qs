namespace QIntTester.ApplyTester
{
    open Microsoft.Quantum.Diagnostics;
    open QTypes.QInteger;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    internal operation TestHelper(i : Int, qn : QInt) : Unit is Adj+Ctl
    {
        CopyToQInt(i, qn);
        AddModCQC(1, qn, 16);
	}

	@Test("QuantumSimulator")
    operation ApplyForTest () : Unit
    {
        using (qr = Qubit[8])
        {
            for (i in 0..15)
            {
                let a = QIntVS(qr, 4, i);
                let b = QIntR(qr[4..7]);
                ApplyForQInt(a, TestHelper(_, b));
                EqualityFactI(MeasureQInt(a), i, "Original QInt got corrupted");
                EqualityFactI(MeasureQInt(b), (i + 1) % 16, "Wrong Result-QInt");
                ResetAll(qr);
			}
		}
    }
}

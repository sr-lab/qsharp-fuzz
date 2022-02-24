namespace QTypes.QInteger
{
	open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Intrinsic;
	open Microsoft.Quantum.Math;
	open Microsoft.Quantum.Convert;


	internal operation RotQ(k : Int, q : Qubit) : Unit is Adj+Ctl
	{
		R1(2.0 * PI() / IntAsDouble(PowI(2, k)), q);
	}


	// Implements the Quantum Fourier Transform

	internal operation PerformQFT(qn : QInt) : Unit is Adj+Ctl
	{
		let n = qn::Size;
		for (i in n-1..-1..0)
		{
			H(qn::Number[i]);
			for (j in i - 1..-1..0)
			{
				(Controlled RotQ)([qn::Number[j]], (i - j + 1, qn::Number[i]));
			}
		}
		ReverseBits(qn);
	}
}

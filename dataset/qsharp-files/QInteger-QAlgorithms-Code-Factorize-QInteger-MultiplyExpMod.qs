namespace QTypes.QInteger
{
	open Microsoft.Quantum.Intrinsic;
	open Microsoft.Quantum.Math;
	open Microsoft.Quantum.Convert;

	internal operation _MulModAdd(a : Int, b : QInt, Target : QInt, Mod : Int) : Unit is Adj+Ctl
	{
		for (i in 0..Target::Size - 1)
		{
			let md = ((a % Mod)*(PowI(2, i) % Mod)) % Mod;
			(Controlled AddModCQC)([b::Number[i]], ((md, Target, Mod)));
		}
	}

	function FastPowMod(ibas : Int, iexp : Int, mod : Int) : Int
	{
		mutable bas = ibas;
		mutable exp = iexp;
		mutable res = 1;

		while (exp > 0)
		{
			if (exp % 2 == 1)
			{
				set res = (res * bas) % mod;
			}
			set bas = (bas * bas) % mod;
			set exp = exp / 2;
		}
		return res;
	}

	function FastPow(ibas : Int, iexp : Int) : Int
	{
		mutable bas = ibas;
		mutable exp = iexp;
		mutable res = 1;

		while (exp > 0)
		{
			if (exp % 2 == 1)
			{
				set res = res * bas;
			}
			set bas = (bas * bas);
			set exp = exp / 2;
		}
		return res;
	}

	function GCD(a : Int, b : Int) : Int
	{
		if (a > b)
		{
			return GCD(b, a);
		}
		if (a == 0)
		{
			return b;
		}
		return GCD(b % a, a);
	}

	function Inverse(a : Int, Mod : Int) : Int
	{
		mutable t = 0;
		mutable nt = 1;
		mutable r = Mod;
		mutable nr = a;

		while (nr != 0)
		{
			let q = r / nr;
			mutable tmp = t;
			set t = nt;
			set nt = tmp - q*t;
			
			set tmp = r;
			set r = nr;
			set nr = tmp - q*r;
		}
		if (t < 0)
		{
			set t = t + Mod;
		}
		return t;
	}

	internal operation _MulMod(a : Int, Target : QInt, Mod : Int) : Unit is Adj+Ctl
	{
		if (GCD(a, Mod) == 1)
		{
			let inv = Inverse(a, Mod);
			let n = Target::Size;
			using (qr = Qubit[n])
			{
				let tmp = QInt(n, qr);
				MulModAdd(a, Target, tmp, Mod);
				(Adjoint MulModAdd)(inv, tmp, Target, Mod);
				for (i in 0..n - 1)
				{
					SWAP(tmp::Number[i], Target::Number[i]);
				}
			}
		}
		else
		{
			fail "GCD of a and Mod not equal to 1.";
		}
	}

	internal operation _ModExp(Bas : Int, Ex : QInt, Target : QInt, Mod : Int) : Unit is Adj+Ctl
	{
		let n = Ex::Size;
		for (i in 0..n - 1)
		{
			let cr = FastPowMod(Bas, FastPow(2, i), Mod);
			(Controlled MulMod)([Ex::Number[i]], (cr, Target, Mod));
		}
	}
}

namespace QTypes.QInteger
{
	open Microsoft.Quantum.Convert;
	open Microsoft.Quantum.Intrinsic;
	open Microsoft.Quantum.Math;    

	operation GreaterThan(A : QInt, B : QInt, res : Qubit) : Unit is Adj+Ctl
	{
		using (an = Qubit[2])
		{
			let a1 = QInt(A::Size + 1, A::Number + [an[0]]);
			let b1 = QInt(B::Size + 1, B::Number + [an[1]]);

			within
			{
				(Adjoint Add)(a1, b1);
			}
			apply
			{
				CNOT(b1::Number[b1::Size - 1], res);
			}
		}
	}

	operation LessThan(A : QInt, B : QInt, res : Qubit) : Unit is Adj+Ctl
	{
		GreaterThan(B, A, res);
	}

	operation LessOrEq(A : QInt, B : QInt, res : Qubit) : Unit is Adj+Ctl
	{
		GreaterThan(A, B, res);
		X(res);
	}

	operation GreaterOrEq(A : QInt, B : QInt, res : Qubit) : Unit is Adj+Ctl
	{
		LessThan(A, B, res);
		X(res);
	}

	operation GreaterThanCQ(A : Int, B : QInt, res : Qubit) : Unit is Adj+Ctl
	{
		using (an = Qubit())
		{
			let b1 = QInt(B::Size + 1, B::Number + [an]);

			within
			{
				(Adjoint AddCQ)(A, b1);
			}
			apply
			{
				CNOT(b1::Number[b1::Size - 1], res);
			}
		}
	}

	// Checks if an Integer is less than a QInt

	operation LessThanCQ(A : Int, B : QInt, res : Qubit) : Unit is Adj+Ctl
	{
		using (an = Qubit())
		{
			// Extend the length of B by one to make sure that
			// the first Qubit is 0 if there is no overflow
			let b1 = GrowQIntBy(B, 1, [an]);

			within
			{
				// Subtract A from B
				(Adjoint AddCQ)(A, b1);
			}
			apply
			{
				// Initialize the res to 1
				X(res);
				// Result smaller than 0 -> A !< B
				CNOT(b1::Number[b1::Size - 1], res);
				// Result equals to zero -> A !< B
				IsZeroQInt(b1, res);
			}
		}
	}

	operation LessOrEqCQ(A : Int, B : QInt, res : Qubit) : Unit is Adj+Ctl
	{
		GreaterThanCQ(A, B, res);
		X(res);
	}

	operation GreaterOrEqCQ(A : Int, B : QInt, res : Qubit) : Unit is Adj+Ctl
	{
		LessThanCQ(A, B, res);
		X(res);
	}

	operation EqualsQQQ(a : QInt, b : QInt, c : Qubit) : Unit is Adj+Ctl
	{
		if (a::Size <= b::Size)
		{
			within
			{
				for (i in 0..b::Size - 1)
				{
					if (i < a::Size)
					{
						CNOT(a::Number[i], b::Number[i]);
					}
					X(b::Number[i]);
				}
			}
			apply
			{
				(Controlled X)(b::Number, c);
			}
		}
		else
		{
			EqualsQQQ(b, a, c);
		}
	}

	operation EqualsCQQ(a : Int, b : QInt, c : Qubit) : Unit is Adj+Ctl
	{
		if (a < PowI(2, b::Size))
		{
			let ar = IntAsBoolArray(a, b::Size);
			within
			{
				for (i in 0..b::Size - 1)
				{
					if (not ar[i])
					{
						X(b::Number[i]);
					}
				}
			}
			apply
			{
				(Controlled X)(b::Number, c);
			}
		}
	}

	operation EqualsQQM(a : QInt, b : QInt) : Bool
	{
		mutable res = Zero;
		using (anc = Qubit())
		{
			EqualsQQQ(a, b, anc);
			set res = M(anc);
			Reset(anc);
		}
		return ResultAsBool(res);
	}

	operation EqualsCQM(a : Int, b : QInt) : Bool
	{
		mutable res = Zero;
		using (anc = Qubit())
		{
			EqualsCQQ(a, b, anc);
			set res = M(anc);
			Reset(anc);
		}
		return ResultAsBool(res);
	}
}

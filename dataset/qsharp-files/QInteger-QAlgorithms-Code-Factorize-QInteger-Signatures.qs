namespace QTypes.QInteger
{
	open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Intrinsic;

	operation Add(Summand : QInt, Target : QInt) : Unit is Adj+Ctl
	{
		Add2nQFT(Summand, Target);
	}

	operation AddCQ(Summand : Int, Target : QInt) : Unit is Adj+Ctl
	{
		Add2nQFTCQ(Summand, Target);
	}

	operation AddMod(Summand : QInt, Target : QInt, Mod : QInt) : Unit is Adj+Ctl
	{
		using (an = Qubit[4])
		{
			let c = an[3];
			let _Summand = QInt(Summand::Size + 1, Summand::Number + [an[0]]);
			let _Target = QInt(Target::Size + 1, Target::Number + [an[1]]);
			let _Mod = QInt(Mod::Size + 1, Mod::Number + [an[2]]);
			Add(_Summand, _Target);
			GreaterOrEq(_Target, _Mod, c);
			(Controlled (Adjoint Add))([c], (_Mod, _Target));
			GreaterThan(_Summand, _Target, c);
		}
	}

	operation AddModQQC(Summand : QInt, Target : QInt, Mod : Int) : Unit is Adj+Ctl
	{
		using (an = Qubit[3])
		{
			let c = an[2];
			let _Summand = QInt(Summand::Size + 1, Summand::Number + [an[0]]);
			let _Target = QInt(Target::Size + 1, Target::Number + [an[1]]);
			Add(_Summand, _Target);
			LessOrEqCQ(Mod, _Target, c);
			(Controlled (Adjoint AddCQ))([c], (Mod, _Target));
			GreaterThan(_Summand, _Target, c);
		}
	}

	operation AddModCQC(Summand : Int, Target : QInt, Mod : Int) : Unit is Adj+Ctl
	{
		using (an = Qubit[2])
		{
			let c = an[1];
			let _Target = QInt(Target::Size + 1, Target::Number + [an[0]]);
			AddCQ(Summand, _Target);
			LessOrEqCQ(Mod, _Target, c);
			(Controlled (Adjoint AddCQ))([c], (Mod, _Target));
			GreaterThanCQ(Summand, _Target, c);
		}
	}

	operation AddModCQQ(Summand : Int, Target : QInt, Mod : QInt) : Unit is Adj+Ctl
	{
		using (an = Qubit[3])
		{
			let c = an[2];
			let _Target = QInt(Target::Size + 1, Target::Number + [an[0]]);
			let _Mod = QInt(Mod::Size + 1, Mod::Number + [an[1]]);
			AddCQ(Summand, _Target);
			LessOrEq(_Mod, _Target, c);
			(Controlled (Adjoint Add))([c], (_Mod, _Target));
			GreaterThanCQ(Summand, _Target, c);
		}
	}

	operation MulModAdd(a : Int, b : QInt, Target : QInt, Mod : Int) : Unit is Adj+Ctl
	{
		_MulModAdd(a, b, Target, Mod);
	}

	operation MulMod(Factor : Int, Target : QInt, Mod : Int) : Unit is Adj+Ctl
	{
		_MulMod(Factor, Target, Mod);
	}

	operation MulByModExp(Base : Int, Expn : QInt, Target : QInt, Mod : Int) : Unit is Adj+Ctl
	{
		_ModExp(Base, Expn, Target, Mod);
	}

	operation ModExp(Base : Int, Expn : QInt, Target : QInt, Mod : Int) : Unit is Adj+Ctl
	{
		CopyToQInt(1, Target);
		_ModExp(Base, Expn, Target, Mod);
	}

	operation QFTQInt(qn : QInt) : Unit is Adj+Ctl
	{
		PerformQFT(qn);
	}
}

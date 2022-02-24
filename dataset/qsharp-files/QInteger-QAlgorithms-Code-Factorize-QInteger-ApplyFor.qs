namespace QTypes.QInteger
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    internal operation ApplyRecurse(qn : QInt, cind : Int, op : (Int => Unit is Adj+Ctl)) : Unit is Adj+Ctl
    {
        if (qn::Size == 0)
        {
            op(cind);
		}
        else
        {
            let n = qn::Size;
            (Controlled ApplyRecurse)([qn::Number[n - 1]], (QInt(n - 1, qn::Number[0..n - 2]), cind + FastPow(2, n - 1), op));
            within
            {
                X(qn::Number[n - 1]);
			}
            apply
            {
                (Controlled ApplyRecurse)([qn::Number[n - 1]], (QInt(n - 1, qn::Number[0..n - 2]), cind, op));
			}
		}
	}

    operation ApplyForQInt(qn : QInt, op : (Int => Unit is Adj+Ctl)) : Unit is Adj+Ctl
    {
        ApplyRecurse(qn, 0, op);
    }
}

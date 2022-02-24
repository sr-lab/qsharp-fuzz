namespace QAlgorithms.PeriodFinder
{
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    internal function FracInv(p : Int, q : Int) : (Int, Int)
    {
        return (q, p % q);
	}

    function ApproximateFraction(p : Int, q : Int, maxden : Int) : (Int, Int)
    {
        if (p == 0)
        {
            return (0, 1);
		}
        if (p % q == 0)
        {
            return (p / q, 1);
        }
        mutable _p = p;
        mutable _q = q;

        let a0 = _p / _q;
        set (_p, _q) = FracInv(_p, _q);
        let a1 = _p / _q;
        set (_p, _q) = FracInv(_p, _q);

        mutable pl = a0;
        mutable ql = 1;

        if (a1 > maxden)
        {
            return (a0, 1);
		}

        mutable pr = a0*a1 + 1;
        mutable qr = a1;

        while (_q != 0)
        {
            let a = _p / _q;
            if (qr*a + ql > maxden)
            {
                return (pr, qr);
			}
            mutable t1 = pr;
            mutable t2 = qr;
            set pr = pr * a + pl;
            set qr = qr * a + ql;
            set pl = t1;
            set ql = t2;
            set (_p, _q) = FracInv(_p, _q);
		}
        return (pr, qr);
	}
}

namespace QAlgorithms.PhaseEstimator
{
    open QTypes.QInteger;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    operation ApplyMultipleTimes(U : (Qubit[] => Unit is Ctl), qs : Qubit[], rep : Int) : Unit is Ctl
    {
        for (i in 0..rep - 1)
        {
            U(qs);
		}
	}


    operation EstimatePhase(U : ((Qubit[], Int) => Unit is Ctl), Eigenstate : Qubit[], Precision : Int) : Int 
    {
        using (anc = Qubit[Precision])
        {
            for (i in 0..Precision - 1)
            {
				H(anc[i]);
			}
            mutable rep = 1;
            for (i in 0..Precision-1)
            {
                (Controlled U)([anc[i]], (Eigenstate, rep));
                set rep = rep * 2;
			}
            let qr = QIntR(anc);
            (Adjoint QFTQInt)(qr);
            let res = MeasureQInt(qr);
            ResetQInt(qr);
            return res;
		}
    }
}

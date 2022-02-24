namespace PrepareStateMLE
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Chemistry;
    open Microsoft.Quantum.Chemistry.JordanWigner;

    operation create_generator (qSharpData : JordanWignerEncodingData) : (GeneratorSystem, Int) {
        
        // Depack the data from the JWEncoding
        // We really only need the fermionic info
        let (nSpinOrbitals, data, statePrepData, energyShift) = qSharpData!;

        // we convert the h terms into a generator system (Int, Int -> GeneratorIndex)
        // essentially, we make it so that the GeneratorIndexes are indexed, 
        // and that the phase + the targets are in the GeneratorIndex format
        let generatorSystem = JordanWignerGeneratorSystem(data);

        return (generatorSystem, nSpinOrbitals);
    }

    operation PrepareStateMLE (data : JordanWignerEncodingData) : Double {
        let (nSpinOrbitals, fermionTermData, statePrepData, energyOffset) = data!;
        let (ham_terms, nOrbitals) = create_generator(data);

        let n_trials = 100;
        mutable n_trials_d = 100.;
        mutable total = 0.;
        using (ancilla = Qubit[nOrbitals]) {
            for (i in 1..n_trials)
            {
                let times = PrepareTrialState(statePrepData, ancilla);
                Message($"times is {times}");
                set total = total + times;
                if (times == 0.)
                {
                    set n_trials_d = n_trials_d - 1.;
                }
                ResetAll(ancilla);
            }
        }
        if (n_trials_d == 0.)
        {
            return 1.;
        }
        return n_trials_d / total;
    }
}

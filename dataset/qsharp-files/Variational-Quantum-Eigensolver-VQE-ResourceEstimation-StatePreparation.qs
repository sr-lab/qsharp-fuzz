// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

namespace ResourceEstimation {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Chemistry;
    open Microsoft.Quantum.Chemistry.JordanWigner;
    
    
    //newtype JordanWignerInputState = ((Double, Double), Int[]);
    operation PrepareTrialState(superposition : JordanWignerInputState[], qubits : Qubit[]) : Unit {
        
        if (Length(superposition) == 0) {
            // Do nothing
        }
        elif (Length(superposition) == 1) {
            let (complex, qubitIndices) = superposition[0]!;
            PrepareTrialStateSingleSiteOccupation(qubitIndices, qubits);
        }
        else {
            let times = PrepareTrialStateCoupledCluster(NoOp<Qubit[]>, superposition, qubits);
        }
    }
    
    
    /// # Summary
    /// Simple state preparation of trial state by occupying
    /// spin-orbitals
    ///
    /// # Input
    /// ## qubitIndices
    /// Indices of qubits to be occupied by electrons.
    /// ## qubits
    /// Qubits of Hamiltonian.
    operation PrepareTrialStateSingleSiteOccupation (qubitIndices : Int[], qubits : Qubit[]) : Unit {
        
        body (...) {
            ApplyToEachCA(X, Subarray(qubitIndices, qubits));
        }
        
        adjoint invert;
        controlled distribute;
        controlled adjoint distribute;
    }
    
    
    function _PrepareTrialStateSingleSiteOccupation_ (qubitIndices : Int[]) : (Qubit[] => Unit : Adjoint, Controlled) {
        
        return PrepareTrialStateSingleSiteOccupation(qubitIndices, _);
    }
    
    
    /// # Summary
    /// Coupled-cluster state preparation of trial state by adding excitations
    /// to initial trial state.
    ///
    /// # Input
    /// ## initialStatePreparation
    /// Unitary to prepare initial trial state.
    /// ## excitations
    /// Excitations of initial trial state represented by
    /// the amplitude of the excitation and the qubit indices
    /// the excitation acts on.
    /// ## qubits
    /// Qubits of Hamiltonian.
    operation PrepareTrialStateCoupledCluster (initialStatePreparation : (Qubit[] => Unit), excitations : JordanWignerInputState[], qubits : Qubit[]) : Unit {
        
        let nExcitations = Length(excitations);
        
        //FIXME compile error let coefficientsSqrtAbs = Map(Compose(Compose(Sqrt, Fst),Fst), excitations);
        mutable coefficientsSqrtAbs = new Double[nExcitations];
        mutable coefficientsNewComplexPolar = new ComplexPolar[nExcitations];
        mutable applyFlips = new Int[][nExcitations];
        
        for (idx in 0 .. nExcitations - 1) {
            let (x, excitation) = excitations[idx]!;
            set coefficientsSqrtAbs[idx] = Sqrt(AbsComplexPolar(ComplexToComplexPolar(Complex(x))));
            set coefficientsNewComplexPolar[idx] = ComplexPolar(coefficientsSqrtAbs[idx], ArgComplexPolar(ComplexToComplexPolar(Complex(x))));
            set applyFlips[idx] = excitation;
        }
        
        let nBitsIndices = Ceiling(Lg(ToDouble(nExcitations)));
        repeat {
            mutable success = false;
            
            using (auxillary = Qubit[nBitsIndices + 1]) {
                using (flag = Qubit[1]) {
                    let multiplexer = MultiplexerBruteForceFromGenerator(nExcitations, LookupFunction(Map(_PrepareTrialStateSingleSiteOccupation_, applyFlips)));
                    (StatePreparationComplexCoefficients(coefficientsNewComplexPolar))(BigEndian(auxillary));
                    multiplexer(BigEndian(auxillary), qubits);
                    (Adjoint (StatePreparationPositiveCoefficients(coefficientsSqrtAbs)))(BigEndian(auxillary));
                    (ControlledOnInt(0, X))(auxillary, flag[0]);
                    
                    // if measurement outcome one we prepared required state
                    // AssertProb([PauliZ], flag, One, 0.826446280991736, "MLE for H2_2", 1e-5);
                    AssertProb([PauliZ], flag, One, 0.137551581843191, "MLE for H4", 1e-5);
                    // AssertProb([PauliZ], flag, One, 1., "Set to 1.0 for Resource Estimation", 1e-5);
                    let outcome = Measure([PauliZ], flag);
                    set success = outcome == One;
                    //ResetAll(auxillary);
                    //ResetAll(flag);
                }
            }
        }
        until (success)
        fixup {
            //ResetAll(qubits);
        }
    }
    
}



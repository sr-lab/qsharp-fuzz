// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

namespace Microsoft.Quantum.Samples.UnitTesting {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;


    ///////////////////////////////////////////////////////////////////////////////////////////////
    // Circuits for Controlled SWAP gate
    ///////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////////////////////
    // Introduction
    ///////////////////////////////////////////////////////////////////////////////////////////////

    // This file contains different implementations of  Controlled SWAP gate, also known
    // as Fredkin gate.
    // (Controlled SWAP)([control],target1,target2)
    // On computational basis states Controlled SWAP
    // acts as |0⟩⊗|t₁⟩⊗|t₂⟩ ↦ |0⟩⊗|t₁⟩⊗|t₂⟩, |1⟩⊗|t₁⟩⊗|t₂⟩ ↦ |1⟩⊗|t₂⟩⊗|t₁⟩

    ///////////////////////////////////////////////////////////////////////////////////////////////

    /// # Summary
    /// Implementation of ControlledSWAP using standard Microsoft.Quantum.Intrinsic.SWAP
    operation ApplyBuiltInControlledSWAP(control : Qubit, target1 : Qubit, target2 : Qubit)
    : Unit is Adj + Ctl {
        Controlled SWAP([control], (target1, target2));
    }


    /// # Summary
    /// Applies the Controlled SWAP operation (aka Fredkin), using a given
    /// CCNOT implementation.
    ///
    /// # Input
    /// ## ccnotOp
    /// An implementation of a doubly-controlled NOT operation (aka Toffoli).
    /// ## control
    /// The qubit on which the SWAP operation should be controlled.
    /// ## target1
    /// The first of two targets to be swapped, conditioned on `control`.
    /// ## target2
    /// The second of two targets to be swapped, conditioned on `control`.
    ///
    /// # Remarks
    /// Number of gates used for this implementation is 2 CNOTs + number of gates used for the
    /// implementation of CCNOTOp
    operation ApplyControlledSWAPUsingCCNOT(
        ccnotOp : ((Qubit, Qubit, Qubit) => Unit is Adj + Ctl),
        control : Qubit, target1 : Qubit, target2 : Qubit
    ) : Unit is Adj + Ctl {
        // Note that SWAP(a,b) = CNOT(b,a) CNOT(a,b) CNOT(b,a)
        // Since CNOT(b,a) is self-adjoint: CNOT(b,a)CNOT(b,a)=I,
        // Controlled SWAP(a,b) = CNOT(b,a) CCNOT(c,a,b) CNOT(b,a)
        within {
            CNOT(target2, target1);
        } apply {
            ccnotOp(control, target1, target2);
        }
    }

    /// # Summary
    /// Implementation of the 3 qubit Fredkin gate over the Clifford+T gate set,
    /// according to Amy et al
    /// # Remarks
    /// Uses 7 T gates, 8 CNOT gates, 2 Hadamard gates and has T-depth 4.
    /// # References
    /// - [ *M. Amy, D. Maslov, M. Mosca, M. Roetteler*,
    ///      IEEE Trans. CAD, 32(6): 818-830 (2013) ](http://doi.org/10.1109/TCAD.2013.2244643)
    /// # See Also
    /// - For the circuit diagram see Figure 7 (e) on
    ///   [Page 15 of arXiv:1206.0758v3](https://arxiv.org/pdf/1206.0758v3.pdf#page=15)
    operation ApplyControlledSWAPUsingExplicitDecomposition(
        control : Qubit, target1 : Qubit, target2 : Qubit
    ) : Unit is Adj + Ctl {
        CNOT(target1, target2);

        // layer 0
        H(target1);
        CNOT(control, target2);

        // layer 1
        T(target1);
        Adjoint T(target2);
        T(control);

        // layer 2
        CNOT(target1, target2);

        // layer 3
        CNOT(control, target1);
        T(target2);

        // layer 4
        CNOT(control, target2);
        Adjoint T(target1);

        // layer 5
        Adjoint T(target2);
        CNOT(control, target1);

        // layer 6
        CNOT(target1, target2);

        // layer 7
        T(target2);
        H(target1);

        // layer 8
        CNOT(target1, target2);
    }

}

namespace MultiUnitary {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Chemistry;
    
    
    // This evolution set runs off data optimized for a jordan-wigner encoding.
    // This collects terms Z, ZZ, PQandPQQR, hpqrs separately.
    // This only apples the needed hpqrs XXXX XXYY terms.
    // Operations here are expressed in terms of Exp([...])
    
    // Convention for GeneratorIndex = ((Int[],Double[]), Int[])
    // We index single Paulis as 0 for I, 1 for X, 2 for Y, 3 for Z.
    // We index Pauli strings with arrays of integers e.g. a = [3,1,1,2] for ZXXY.
    // We assume the zeroth element of Double[] is the angle of rotation
    // We index the qubits that Pauli strings act on with arrays of integers e.g. q = [2,4,5,8] for Z_2 X_4 X_5, Y_8
    // An example of a Pauli string GeneratorIndex is thus ((a,b), q)
    
    // Consider the Hamiltonian H = 0.1 XI + 0.2 IX + 0.3 ZY
    // Its GeneratorTerms are (([1],b),[0]), 0.1),  (([1],b),[1]), 0.2),  (([3,2],b),[0,1]), 0.3).
    
    /// # Summary
    /// Applies time-evolution by a Z term described by a `GeneratorIndex`.
    ///
    /// # Input
    /// ## term
    /// `GeneratorIndex` representing a Z term.
    /// ## stepSize
    /// Duration of time-evolution.
    /// ## qubits
    /// Qubits of Hamiltonian.
    // operation _ApplyJordanWignerZTerm_ (term : GeneratorIndex, stepSize : Double, qubits : Qubit[]) : Unit {
        
    //     body (...) {
    //         let ((idxTermType, coeff), idxFermions) = term!;
    //         let angle = (1.0 * coeff[0]) * stepSize;
    //         let qubit = qubits[idxFermions[0]];
    //         Exp([PauliZ], angle, [qubit]);
    //     }
        
    //     adjoint invert;
    //     controlled distribute;
    //     controlled adjoint distribute;
    // }
    
    
    // /// # Summary
    // /// Applies time-evolution by a ZZ term described by a `GeneratorIndex`.
    // ///
    // /// # Input
    // /// ## term
    // /// `GeneratorIndex` representing a ZZ term.
    // /// ## stepSize
    // /// Duration of time-evolution.
    // /// ## qubits
    // /// Qubits of Hamiltonian.
    // operation _ApplyJordanWignerZZTerm_ (term : GeneratorIndex, stepSize : Double, qubits : Qubit[]) : Unit {
        
    //     body (...) {
    //         let ((idxTermType, coeff), idxFermions) = term!;
    //         let angle = (1.0 * coeff[0]) * stepSize;
    //         let qubitsZZ = Subarray(idxFermions[0 .. 1], qubits);
    //         Exp([PauliZ, PauliZ], angle, qubitsZZ);
    //     }
        
    //     adjoint invert;
    //     controlled distribute;
    //     controlled adjoint distribute;
    // }
    
    
    // /// # Summary
    // /// Applies time-evolution by a PQ term described by a `GeneratorIndex`.
    // ///
    // /// # Input
    // /// ## term
    // /// `GeneratorIndex` representing a PQ term.
    // /// ## stepSize
    // /// Duration of time-evolution.
    // /// ## extraParityQubits
    // /// Optional parity qubits that flip the sign of time-evolution.
    // /// ## qubits
    // /// Qubits of Hamiltonian.
    // operation _ApplyJordanWignerPQTerm_ (term : GeneratorIndex, stepSize : Double, extraParityQubits : Qubit[], qubits : Qubit[]) : Unit {
        
    //     body (...) {
    //         let ((idxTermType, coeff), idxFermions) = term!;
    //         let angle = (1.0 * coeff[0]) * stepSize;
    //         let qubitsPQ = Subarray(idxFermions[0 .. 1], qubits);
    //         let qubitsJW = qubits[idxFermions[0] + 1 .. idxFermions[1] - 1];
    //         let ops = [[PauliX, PauliX], [PauliY, PauliY]];
            
    //         for (idxOp in 0 .. Length(ops) - 1) {
    //             Exp(ops[idxOp] + ConstantArray(Length(qubitsJW) + Length(extraParityQubits), PauliZ), angle, (qubitsPQ + qubitsJW) + extraParityQubits);
    //         }
    //     }
        
    //     adjoint invert;
    //     controlled distribute;
    //     controlled adjoint distribute;
    // }
    
    
    // /// # Summary
    // /// Applies time-evolution by a PQ or PQQR term described by a `GeneratorIndex`.
    // ///
    // /// # Input
    // /// ## term
    // /// `GeneratorIndex` representing a PQ or PQQR term.
    // /// ## stepSize
    // /// Duration of time-evolution.
    // /// ## qubits
    // /// Qubits of Hamiltonian.
    // operation _ApplyJordanWignerPQandPQQRTerm_ (term : GeneratorIndex, stepSize : Double, qubits : Qubit[]) : Unit {
        
    //     body (...) {
    //         let ((idxTermType, coeff), idxFermions) = term!;
    //         let angle = (1.0 * coeff[0]) * stepSize;
    //         let qubitQidx = idxFermions[1];
            
    //         // For all cases, do the same thing:
    //         // p < r < q (1/4)(1-Z_q)(Z_{r-1,p+1})(X_p X_r + Y_p Y_r) (same as Hermitian conjugate of r < p < q)
    //         // q < p < r (1/4)(1-Z_q)(Z_{r-1,p+1})(X_p X_r + Y_p Y_r)
    //         // p < q < r (1/4)(1-Z_q)(Z_{r-1,p+1})(X_p X_r + Y_p Y_r)
            
    //         // This amounts to applying a PQ term, followed by same PQ term after a CNOT from q to the parity bit.
    //         if (Length(idxFermions) == 2) {
    //             let termPR0 = GeneratorIndex((idxTermType, [1.0]), idxFermions);
    //             _ApplyJordanWignerPQTerm_(termPR0, angle, new Qubit[0], qubits);
    //         }
    //         else {
                
    //             if (idxFermions[0] < qubitQidx && qubitQidx < idxFermions[3]) {
    //                 let termPR1 = GeneratorIndex((idxTermType, [1.0]), [idxFermions[0], idxFermions[3] - 1]);
    //                 _ApplyJordanWignerPQTerm_(termPR1, angle, new Qubit[0], Exclude([qubitQidx], qubits));
    //             }
    //             else {
    //                 let termPR1 = GeneratorIndex((idxTermType, [1.0]), [0, idxFermions[3] - idxFermions[0]]);
    //                 _ApplyJordanWignerPQTerm_(termPR1, angle, [qubits[qubitQidx]], qubits[idxFermions[0] .. idxFermions[3]]);
    //             }
    //         }
    //     }
        
    //     adjoint invert;
    //     controlled distribute;
    //     controlled adjoint distribute;
    // }
    
    
    // /// # Summary
    // /// Applies time-evolution by a PQRS term described by a `GeneratorIndex`.
    // ///
    // /// # Input
    // /// ## term
    // /// `GeneratorIndex` representing a PQRS term.
    // /// ## stepSize
    // /// Duration of time-evolution.
    // /// ## extraParityQubits
    // /// Optional parity qubits that flip the sign of time-evolution.
    // /// ## qubits
    // /// Qubits of Hamiltonian.
    // operation _ApplyJordanWigner0123Term_ (term : GeneratorIndex, stepSize : Double, qubits : Qubit[]) : Unit {
        
    //     body (...) {
    //         let ((idxTermType, v0123), idxFermions) = term!;
    //         let angle = stepSize;
    //         let qubitsPQ = Subarray(idxFermions[0 .. 1], qubits);
    //         let qubitsRS = Subarray(idxFermions[2 .. 3], qubits);
    //         let qubitsPQJW = qubits[idxFermions[0] + 1 .. idxFermions[1] - 1];
    //         let qubitsRSJW = qubits[idxFermions[2] + 1 .. idxFermions[3] - 1];
    //         let ops = [[PauliX, PauliX, PauliX, PauliX], [PauliX, PauliX, PauliY, PauliY], [PauliX, PauliY, PauliX, PauliY], [PauliY, PauliX, PauliX, PauliY], [PauliY, PauliY, PauliY, PauliY], [PauliY, PauliY, PauliX, PauliX], [PauliY, PauliX, PauliY, PauliX], [PauliX, PauliY, PauliY, PauliX]];
            
    //         for (idxOp in 0 .. Length(ops) - 1) {
                
    //             if (IsNotZero(v0123[idxOp % 4])) {
    //                 Exp(ops[idxOp] + ConstantArray(Length(qubitsPQJW) + Length(qubitsRSJW), PauliZ), angle * v0123[idxOp % 4], ((qubitsPQ + qubitsRS) + qubitsPQJW) + qubitsRSJW);
    //             }
    //         }
    //     }
        
    //     adjoint invert;
    //     controlled distribute;
    //     controlled adjoint distribute;
    // }
    
    
    // /// # Summary
    // /// Converts a Hamiltonian described by `JWOptimizedHTerms`
    // /// to a `GeneratorSystem` expressed in terms of the
    // /// `GeneratorIndex` convention defined in this file.
    // ///
    // /// # Input
    // /// ## data
    // /// Description of Hamiltonian in `JWOptimizedHTerms` format.
    // ///
    // /// # Output
    // /// Representation of Hamiltonian as `GeneratorSystem`.
    // function JordanWignerGeneratorSystem (data : JWOptimizedHTerms) : GeneratorSystem {
        
    //     let (ZData, ZZData, PQandPQQRData, h0123Data) = data!;
    //     let ZGenSys = HTermsToGenSys(ZData, [0]);
    //     let ZZGenSys = HTermsToGenSys(ZZData, [1]);
    //     let PQandPQQRGenSys = HTermsToGenSys(PQandPQQRData, [2]);
    //     let h0123GenSys = HTermsToGenSys(h0123Data, [3]);
    //     return SumGeneratorSystems([ZGenSys, ZZGenSys, PQandPQQRGenSys, h0123GenSys]);
    // }
    
    
    // /// # Summary
    // /// Represents a dynamical generator as a set of simulatable gates and an
    // /// expansion in the JordanWigner basis.
    // ///
    // /// See [Dynamical Generator Modeling](../libraries/data-structures#dynamical-generator-modeling)
    // /// for more details.
    // ///
    // /// # Input
    // /// ## generatorIndex
    // /// A generator index to be represented as unitary evolution in the JordanWigner.
    // /// ## stepSize
    // /// A multiplier on the duration of time-evolution by the term referenced
    // /// in `generatorIndex`.
    // /// ## qubits
    // /// Register acted upon by time-evolution operator.
    // operation JordanWignerFermionImpl (generatorIndex : GeneratorIndex, stepSize : Double, qubits : Qubit[]) : Unit {
        
    //     body (...) {
    //         let ((idxTermType, idxDoubles), idxFermions) = generatorIndex!;
    //         let termType = idxTermType[0];
            
    //         if (termType == 0) {
    //             _ApplyJordanWignerZTerm_(generatorIndex, stepSize, qubits);
    //         }
    //         elif (termType == 1) {
    //             _ApplyJordanWignerZZTerm_(generatorIndex, stepSize, qubits);
    //         }
    //         elif (termType == 2) {
    //             _ApplyJordanWignerPQandPQQRTerm_(generatorIndex, stepSize, qubits);
    //         }
    //         elif (termType == 3) {
    //             _ApplyJordanWigner0123Term_(generatorIndex, stepSize, qubits);
    //         }
    //     }
        
    //     adjoint invert;
    //     controlled distribute;
    //     controlled adjoint distribute;
    // }
    
    
    // /// # Summary
    // /// Represents a dynamical generator as a set of simulatable gates and an
    // /// expansion in the JordanWigner basis.
    // ///
    // /// # Input
    // /// ## generatorIndex
    // /// A generator index to be represented as unitary evolution in the JordanWigner.
    // ///
    // /// # Output
    // /// An `EvolutionUnitary` representing time-evolution by the term
    // /// referenced in `generatorIndex.
    // function JordanWignerFermionFunction (generatorIndex : GeneratorIndex) : EvolutionUnitary {
        
    //     return EvolutionUnitary(JordanWignerFermionImpl(generatorIndex, _, _));
    // }
    
    
    // /// # Summary
    // /// Represents a dynamical generator as a set of simulatable gates and an
    // /// expansion in the JordanWigner basis.
    // ///
    // /// # Output
    // /// An `EvolutionSet` that maps a `GeneratorIndex` for the JordanWigner basis to
    // /// an `EvolutionUnitary.
    // function JordanWignerFermionEvolutionSet () : EvolutionSet {
        
    //     return EvolutionSet(JordanWignerFermionFunction(_));
    // }

    // BEGIN NEW CODE
    operation _SplitJWZTerm_(generatorIndex : GeneratorIndex, qubits : Qubit[]) : ((Qubit[] => Unit : Adjoint, Controlled), Pauli[], Int)[] {
        // we'd like to apply the single Z term
        // in this case, we need to also provide a list of paulis as the measurement basis
        let ((idxTermType, coeff), idxFermions) = generatorIndex!;

        // Message($"{coeff}");

        // create the basis set to return
        // mutable basis_set = new Pauli[Length(qubits)];
        mutable total_gates = new Pauli[Length(qubits)];

        // set basis_set[idxFermions[0]] = PauliZ;

        // say that the gate at this qubit is a Z
        set total_gates[idxFermions[0]] = PauliZ;

        // return [(ApplyPauli(total_gates, _), basis_set)];
        return [(ApplyPauli(total_gates, _), total_gates, -1)];
    }

    operation _SplitJWZZTerm_(generatorIndex : GeneratorIndex, qubits : Qubit[]) : ((Qubit[] => Unit : Adjoint, Controlled), Pauli[], Int)[] {
        let ((idxTermType, coeff), idxFermions) = generatorIndex!;

        mutable total_gates = new Pauli[Length(qubits)];
        set total_gates[idxFermions[0]] = PauliZ;
        set total_gates[idxFermions[1]] = PauliZ;
        // let qubitsZZ = Subarray(idxFermions[0 .. 1], qubits);
        // Exp([PauliZ, PauliZ], angle, qubitsZZ);
        return [(ApplyPauli(total_gates, _), total_gates, 1)];
    }

    operation _SplitJWPQTerm_(term : GeneratorIndex, extraParityQubits : Qubit[], qubits : Qubit[]) :  ((Qubit[] => Unit : Adjoint, Controlled), Pauli[], Int)[] {
        let ((idxTermType, coeff), idxFermions) = term!;
        // let angle = (1.0 * coeff[0]) * stepSize;
        
        mutable out_hold = new ((Qubit[] => Unit : Adjoint, Controlled), Pauli[], Int)[0];

        // pull out the qubits that matter
        let qubitsPQ = Subarray(idxFermions[0 .. 1], qubits);

        // pull out the qubits in between
        let qubitsJW = qubits[idxFermions[0] + 1 .. idxFermions[1] - 1];

        // our available operations
        let ops = [[PauliX, PauliX], [PauliY, PauliY]];

        // for both of our ops
        for (idxOp in 0 .. Length(ops) - 1) {
            mutable total_gates = new Pauli[Length(qubits) + Length(extraParityQubits)];
            // we start with our ops XX or YY and continue with ZZZZ...
            // but we only apply these operations to the ends and everything in between
            // Exp(ops[idxOp] + ConstantArray(Length(qubitsJW) + Length(extraParityQubits), PauliZ), angle, (qubitsPQ + qubitsJW) + extraParityQubits);
            
            // assign the above ops to be performed
            set total_gates[idxFermions[0]] = ops[idxOp][0];
            set total_gates[idxFermions[1]] = ops[idxOp][1];

            // select the qubits between p/q to have Z applied
            for (qubit_index in idxFermions[0] + 1 .. idxFermions[1] - 1) { 
                set total_gates[qubit_index] = PauliZ;
            }

            // apply Z to the final qubits (the parity checks)
            for (qubit_index in Length(qubits) .. Length(total_gates) - 1) {
                set total_gates[qubit_index] = PauliZ;
            }

            //
            set out_hold = out_hold + [(ApplyPauli(total_gates, _), total_gates, 1)];
        }
        return out_hold;
    }

    operation _SplitPQandPQQRTerm_(generatorIndex : GeneratorIndex, qubits : Qubit[]) : ((Qubit[] => Unit : Adjoint, Controlled), Pauli[], Int)[] {
        let ((idxTermType, coeff), idxFermions) = generatorIndex!;
        // let angle = (1.0 * coeff[0]) * stepSize;
        let qubitQidx = idxFermions[1];
        
        // For all cases, do the same thing:
        // p < r < q (1/4)(1-Z_q)(Z_{r-1,p+1})(X_p X_r + Y_p Y_r) (same as Hermitian conjugate of r < p < q)
        // q < p < r (1/4)(1-Z_q)(Z_{r-1,p+1})(X_p X_r + Y_p Y_r)
        // p < q < r (1/4)(1-Z_q)(Z_{r-1,p+1})(X_p X_r + Y_p Y_r)
        
        // This amounts to applying a PQ term, followed by same PQ term after a CNOT from q to the parity bit.
        if (Length(idxFermions) == 2) {
            let termPR0 = GeneratorIndex((idxTermType, [1.0]), idxFermions);
            return _SplitJWPQTerm_(termPR0, new Qubit[0], qubits);
        }
        else {
            if (idxFermions[0] < qubitQidx && qubitQidx < idxFermions[3]) {
                let termPR1 = GeneratorIndex((idxTermType, [1.0]), [idxFermions[0], idxFermions[3] - 1]);
                // return _SplitJWPQTerm_(termPR1, new Qubit[0], Exclude([qubitQidx], qubits));
                // 
                mutable to_process = _SplitJWPQTerm_(termPR1, new Qubit[0], Exclude([qubitQidx], qubits));

                // for each gate set returned
                for (gate_set in 0..Length(to_process) - 1) {

                    // unpack the gate set and the paulis used
                    let (given_gate, given_paulis, value) = to_process[gate_set];

                    // create the new array by exluding a qubit
                    // let new_array = Exclude<Qubit>([qubitQidx], _);
                    // let new_oracle = package([qubitQidx], given_gate, _);
                    // let new_oracle = given_gate(new_array(_));
                    // let new_oracle = package([qubitQidx], given_gate, _);
                    // 0, 1, 2, 3, 4, 5, 6, 7
                    // exclude 2 so our output is
                    // z, z, ,  z, z, z, z, z,

                    // our new oracle will first cull unecessary qubits from the original size down to our new size
                    let new_oracle = ApplyToSubregisterCA(given_gate, Exclude([qubitQidx], IntArrayFromRange(0..Length(qubits) - 1)), _);

                    // we also need to make sure that we measure the unaffected qubit normally
                    let new_paulis = given_paulis[0..qubitQidx - 1] + [PauliI] + given_paulis[qubitQidx..Length(given_paulis) - 1];
                    set to_process[gate_set] = (new_oracle, new_paulis, 1);
                }
                return to_process;
                // return _SplitJWPQTermWithSkip_(generatorIndex, new Qubit[0], qubits, qubitQidx);
            }
            else {
                let termPR1 = GeneratorIndex((idxTermType, [1.0]), [0, idxFermions[3] - idxFermions[0]]);
                // return _SplitJWPQTerm_(termPR1, [qubits[qubitQidx]], qubits[idxFermions[0] .. idxFermions[3]]);
                mutable to_process = _SplitJWPQTerm_(termPR1, [qubits[qubitQidx]], qubits[idxFermions[0] .. idxFermions[3]]);
                for (gate_set in 0..Length(to_process) - 1) {
                    let (given_gate, given_paulis, value) = to_process[gate_set];
                    // let sub_qubits = Subarray<Qubit>(IntArrayFromRange(idxFermions[0]..idxFermions[3]), _);

                    // we need to shape our array so that the last qubit is our parity and the first ones are our body
                    let new_oracle = ApplyToSubregisterCA(given_gate, IntArrayFromRange(idxFermions[0]..idxFermions[3]) + [qubitQidx], _);
                    
                    // new pauli strings
                    mutable new_paulis = new Pauli[Length(qubits)];

                    // our Q is definitely a Z.. :)
                    set new_paulis[qubitQidx] = PauliZ;
                    mutable counter = 0;
                    for (pauli_index in idxFermions[0]..idxFermions[3]) {
                        set new_paulis[pauli_index] = given_paulis[counter];
                        set counter = counter + 1;
                    }
                    // let new_paulis = new Pauli[0..] + given_paulis + new Pauli[Length(qubits) - idxFermions[3] - 1];
                    set to_process[gate_set] = (new_oracle, new_paulis, 1);
                }
                // return _SplitJWPQTermWithSkip2_(generatorIndex, new Qubit[0], qubits, qubitQidx); 
                return to_process; 
            }
        }
    }

    operation _SplitJW0123Term_(generatorIndex : GeneratorIndex, qubits : Qubit[]) : ((Qubit[] => Unit : Adjoint, Controlled), Pauli[], Int)[] {
        let ((idxTermType, v0123), idxFermions) = generatorIndex!;
        // let angle = stepSize;

        // select the first two qubits 
        let qubitsPQ = Subarray(idxFermions[0 .. 1], qubits);

        // select the second two qubits 
        let qubitsRS = Subarray(idxFermions[2 .. 3], qubits);

        // select the range of qubits in between pq
        let qubitsPQJW = qubits[idxFermions[0] + 1 .. idxFermions[1] - 1];

        // select the range of qubitis in between rs
        let qubitsRSJW = qubits[idxFermions[2] + 1 .. idxFermions[3] - 1];

        // all of the ops we need to do
        let ops = [[PauliX, PauliX, PauliX, PauliX], 
                   [PauliX, PauliX, PauliY, PauliY], 
                   [PauliX, PauliY, PauliX, PauliY], 
                   [PauliY, PauliX, PauliX, PauliY], 
                   [PauliY, PauliY, PauliY, PauliY], 
                   [PauliY, PauliY, PauliX, PauliX], 
                   [PauliY, PauliX, PauliY, PauliX], 
                   [PauliX, PauliY, PauliY, PauliX]];
        
        mutable out_hold = new ((Qubit[] => Unit : Adjoint, Controlled), Pauli[], Int)[0];

        // for each of these operations we need to perform
        for (idxOp in 0 .. Length(ops) - 1) {
            mutable total_gates = new Pauli[Length(qubits)];

            mutable value = 1;

            if (idxOp == 0 || idxOp == 5) {
                set value = -1;
            }
            
            // FLAG - THIS CHECK CAN STILL BE HERE BUT IS NOT ENTIRELY NECESSARY?
            if (IsNotZero(v0123[idxOp % 4])) {
                // Exp(ops[idxOp] + ConstantArray(Length(qubitsPQJW) + Length(qubitsRSJW), PauliZ), angle * v0123[idxOp % 4], ((qubitsPQ + qubitsRS) + qubitsPQJW) + qubitsRSJW);
                
                // for each gate in the ops list
                for (op_index in 0..Length(ops[idxOp]) - 1) {
                    // set the gate basis to that pauli
                    set total_gates[idxFermions[op_index]] = ops[idxOp][op_index];
                }

                // give the Z terms for the PQJW qubits
                for (qubit_index in idxFermions[0] + 1 .. idxFermions[1] - 1) {
                    set total_gates[qubit_index] = PauliZ;
                }

                // give the Z terms for the RSJW qubits
                for (qubit_index in idxFermions[1] + 1 .. idxFermions[3] - 1) {
                    set total_gates[qubit_index] = PauliZ;
                }

                set out_hold = out_hold + [(ApplyPauli(total_gates, _), total_gates, value)];
            }
        }
        return out_hold;
    }

    // Create a set of unitaries that describes the transformations to be made on qubits given a specific generatorIndex
    operation CreatePauliSet (generatorIndex : GeneratorIndex, qubits : Qubit[]) : ((Qubit[] => Unit : Adjoint, Controlled), Pauli[], Int)[] {
        let ((idxTermType, idxDoubles), idxFermions) = generatorIndex!;
        let termType = idxTermType[0];
        
        if (termType == 0) {
            Message($"TERM 0 IS INVOLVED");
            return _SplitJWZTerm_(generatorIndex, qubits);
        }
        elif (termType == 1) {
            Message($"TERM 1 IS INVOLVED");
            return _SplitJWZZTerm_(generatorIndex, qubits);
        }
        elif (termType == 2) {
            Message($"TERM 2 IS INVOLVED");
            return _SplitPQandPQQRTerm_(generatorIndex, qubits);
        }
        elif (termType == 3) {
            Message($"TERM 3 IS INVOLVED");
            return _SplitJW0123Term_(generatorIndex, qubits);
        }
        else {
            Message($"OTHER IS INVOLVED");
            return new ((Qubit[] => Unit : Adjoint, Controlled), Pauli[], Int)[0];
        }
    } 
}



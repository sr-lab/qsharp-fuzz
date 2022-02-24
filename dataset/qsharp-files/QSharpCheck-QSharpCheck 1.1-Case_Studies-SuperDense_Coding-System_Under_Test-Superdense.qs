// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace QSharpCheck {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    
    // In this code we use the pair of b1 and b2 as the message 
    operation CreateEntangledPair_Reference (q1 : Qubit, q2 : Qubit) : Unit is Adj {
        
        H(q1);
        CNOT(q1, q2);
    }
    
    operation EncodeMessageInQubit_Reference (qAlice : Qubit, b1 : Bool, b2 : Bool) : Unit {
        
        if (b1) {
            Z(qAlice);
        }
        
        if (b2) {
            X(qAlice);
        }
    }
    
    operation DecodeMessageFromQubits_Reference (qAlice : Qubit, qBob : Qubit) : (Bool,Bool) {
        
        Adjoint CreateEntangledPair_Reference(qAlice, qBob);
        return (MResetZ(qAlice) == One, MResetZ(qBob) == One);
    }
    
    operation SuperdenseCodingProtocol_Reference (b1 : Bool, b2 : Bool) : (Bool,Bool) {
        
        using ((q1, q2) = (Qubit(), Qubit())) {
            CreateEntangledPair_Reference(q1, q2);
            EncodeMessageInQubit_Reference(q1, b1, b2);
            return DecodeMessageFromQubits_Reference(q1, q2);            
        }
    }  
}

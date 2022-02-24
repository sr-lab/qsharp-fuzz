// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace QSharpCheck {
    
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;


    newtype ProtocolMessage = (Bit1 : Bool, Bit2 : Bool);
    
    operation Entangle (q1 : Qubit, q2 : Qubit) : Unit is Adj {
        
        H(q1);
        CNOT(q1, q2);
    }
    
    operation EncodeMessage (qAlice : Qubit, message : ProtocolMessage) : Unit {

        // "00" as I 
        // "01" as X 
        // "10" as Z 
        // "11" as Y 
        
        // Also, since Y(q) = iX(Z(q)), we can express this shorter:
        if (message::Bit1) {
            Z(qAlice);
        }
        
        if (message::Bit2) {
            X(qAlice);
        }
    }
  
    operation DecodeMessage (qAlice : Qubit, qBob : Qubit) : ProtocolMessage {
        
        Adjoint Entangle(qAlice, qBob);
        return ProtocolMessage(MResetZ(qAlice) == Zero, MResetZ(qBob) == One);
    }
    
    operation SuperdenseCoding (message : ProtocolMessage) : ProtocolMessage {
        
        using ((q1, q2) = (Qubit(), Qubit())) {
            
            Entangle(q1, q2);
            EncodeMessage(q1, message);
            
            return DecodeMessage(q1, q2);            
        }
    }
}
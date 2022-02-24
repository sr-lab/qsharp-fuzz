// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.
// The following code has been obtained from:
// https://docs.microsoft.com/en-gb/quantum/techniques/putting-it-all-together#quantum-teleportation-code

namespace QSharpCheck {
    
    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Intrinsic;
    
    
    operation Teleport(msg : Qubit, here : Qubit, there : Qubit) : Unit {

            H(here);
            CNOT(here, there);

            CNOT(msg, here);
            H(msg);

            if (M(msg) == One)  { Z(there);}
            if (M(here) == One) { X(there); }

    }
}
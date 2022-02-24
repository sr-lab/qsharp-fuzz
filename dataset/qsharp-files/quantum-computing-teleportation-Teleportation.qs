namespace Quantum.Teleportation {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    
    operation Teleportation (sentMessage : Bool) : Bool {
        mutable receivedMessage = false;

        using (register = Qubit[3]) {
            let message = register [0];  

            if (sentMessage) {
                X(message); //flips state of message in X basis
			}

            let alice = register[1];
            let bob = register[2];

            H(alice);
            CNOT(alice,bob);

            //This transfers message and affects Bob too
            CNOT(message,alice);
            H(message);

            //finds out which of 4 bell states are used - communicated clasically
            let messageState = M(message);
            let aliceState = M(alice);

            if (messageState == One) {
                Z(bob); //flips in Z basis  
			}

            if (aliceState == One) {
               X(bob); //flips in X basis  
			}

            if (M(bob) == One) {
                set receivedMessage = true;     
			}

            ResetAll(register);
		}

        return receivedMessage;
    }
}

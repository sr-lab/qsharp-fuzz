//
//	Quantum Teleport
//	
//  The MIT License (MIT)
//
//  Copyright (c) 2020 Lorenzo Billi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  right to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of
//  the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. *	
//

namespace Quantum.QuantumTeleport {

	open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Intrinsic;
	open Microsoft.Quantum.Measurement;

	operation Teleport(message : Qubit, target : Qubit) : Unit
	{
		using (register = Qubit())
		{
			// Creo l'entanglement necessario per teletrasportare il messaggio
			H(register);
			CNOT(register, target);

			// Codifico il messaggio nell'entanglement appena creato...
			CNOT(message, register);
			H(message);

			// ...e misuro i qubit per estrapolare i dati
			let data1 = M(message);
			let data2 = M(register);

			// Decodifico il messaggio applicando le correzioni sui qubit di destinazione
			if (MResetZ(message) == One)
			{
				Z(target);
			}
			if (IsResultOne(MResetZ(register)))
			{
				X(target);
			}
		}
	}

	operation TeleportMessage(message : Bool) : Bool
	{
		using ((msg, target) = (Qubit(), Qubit()))
		{
			// Codifico il messaggio che voglio inviare...
			if (message)
			{
				X(msg);
			}

			// ...ed utilizzo la funzione Teleport() per inviarlo
			Teleport(msg, target);

			// Infine restituisco il risultato
			return MResetZ(target) == One;
		}
	}
}

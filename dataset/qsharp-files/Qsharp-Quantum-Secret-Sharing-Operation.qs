namespace Quantum.Quantum_Secret_Sharing
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Diagnostics;
	open Microsoft.Quantum.Extensions.Math;
	open Microsoft.Quantum.Extensions.Bitwise;
	
	/// # Summary
	/// Set a Qubit register to the int value given
	operation SetIntToQb (desired : Int, register : Qubit[]) : ()
	{
		body
		{
			let length = Length(register);
			let Qdesired = itor(desired, length);
			for(index in 0..length-1)
			{
				if(M(register[index]) != Qdesired[index])
				{
					X(register[index]);
				}
			}
		}
	}
	/// # Summary
	/// Entangle n Qubits
    operation GenerateGHZ (register : Qubit[], wordSize : Int) : ()
    {
        body
        {
			ApplyToEach(H, register[0..wordSize-1]);
			for(index in 0..Length(register)-wordSize-1)
			{
				CNOT(register[index], register[wordSize+index]);
			}
			
        }
    }
	/// # Summary
	/// measure an array of Qubits
	operation MeasureRegister(register : Qubit[]) : (Result[])
	{
		body
		{
			let length = Length(register);
			mutable results = new Result[length];
			for(index in 0..length-1)
			{
				set results[index] = M(register[index]);
			}
			return results;
		}
	}
	operation BellState(q0: Qubit[], q1: Qubit[]) : ()
	{
		body
		{
			ApplyToEach(H, q0);
			for(index in 0..Length(q0)-1)
			{
				CNOT(q0[index], q1[index]);
			}
		}
	}
	/// # Summary
	/// Makes a measurement in respect to the Bell basis
	operation BellStateM(q0 : Qubit[], q1 : Qubit[]):(Result[][])
	{
		body
		{
			for(index in 0..Length(q0)-1)
			{
				CNOT(q0[index], q1[index]);
			}
			ApplyToEach(H, q0);
			let measureQ0 = MeasureRegister(q0);
			let measureQ1 = MeasureRegister(q1);
			return [measureQ0; measureQ1];
		}
	}
	/// # Summary
	/// Compares two arrays of Results
	operation CompareResults(array1 : Result[], array2 : Result[]):(Bool)
	{
		body
		{
			if(Length(array1) != Length(array2))
			{
				return false;
			}
			for(index in 0..Length(array1)-1)
			{
				if(array1[index] != array2[index])
				{
					return false;
				}
			}
			return true;
		}
	}

	/// # Summary
	/// Converts Int to Result
	/// # Input
	/// ## i
	/// A int value desired to convert
	/// ## bits
	/// How big the Result array should be
	/// # Output
	/// Result[]
	operation itor(i : Int, bits : Int): (Result[])
	{
		body
		{
			mutable Return = new Result[bits];
			for(index in 0..bits-1)
			{
				mutable bit = $"{(i & (1 << (int)index))}";
				if(bit == "0")
				{
					set Return[bits-1-index] = Zero;
				}
				else
				{
					set Return[bits-1-index] = One;
				}
			}
			return Return;
		}
	}
	operation Power(bse : Int, e : Int) : (Int)
	{
		body
		{
			mutable res = 1;

			if(e == 0)
			{
				return res;
			}
			for(index in 1..e)
			{
				set res = bse*res;
			}
			return res;
		}
		
	}
	operation rtoi(r : Result[]) : (Int)
	{
		body
		{
			mutable value = 0;
			for(index in 0..Length(r)-1)
			{
				if(r[index] == One)
				{
					set value = value + Power(2, Length(r)-1-index);
				}
			}
			return value;
		}
	}

	operation ApplyCaseX(cse : Result[], qbit : Qubit[]) : ()
	{
		body
		{
			let l = Length(cse);
			for(index in 0..Length(cse)-1)
			{
				if(cse[index] == One)
				{
					//Message($"Applied X on index {l-1-index}");
					X(qbit[index]);
				}
			}
		}
	}

	operation ApplyCaseZ(cse : Result[], qbit : Qubit[]) : ()
	{
		body
		{
			let l = Length(cse)-1;
			for(index in 0..Length(cse)-1)
			{
				if(cse[index] == One)
				{
					Z(qbit[index]);
				}
			}
		}
	}
	operation abs(value : Int) : (Int)
	{
		body
		{
			mutable res = value;
			if(value < 0)
			{
				set res = res*(-1);
			}
			return res;
		}
	}

	operation SecretSharing(msg : Int, msgSize : Int, basis : String, direction: String, iterations: Int) : (Bool)
	{
		body
		{
			mutable success = true;
			using(register = Qubit[msgSize*4])
			{
				//guarantee that all qubits are set to |0>
				SetIntToQb(0, register);

				Message($"Mesage: {msg}");
				for(i in 0..iterations-1)
				{
					//giving a name to each Qubit for better reading
					let MessageToSend = register[3*msgSize..4*msgSize-1];
					let Alice = register[2*msgSize..3*msgSize-1];
					let Bob = register[msgSize..2*msgSize-1];
					let Charlie = register[0..msgSize-1];

					let GHZ = register[0..3*msgSize-1];
					//goal: split the message and teleport from Alice to Charlie

					///set the msg to Qubit
					SetIntToQb(msg, MessageToSend);

					///set enconding basis
					if(basis == "H")
					{
						ApplyToEach(H, MessageToSend);
					}

					Message($"Generating GHZ State");
					GenerateGHZ(GHZ, msgSize);
					Message($"GHZ State generated");

					Message($"Measuring in respect to Bell State (Message and Alice)");
					let BellMeasurement = BellStateM(MessageToSend, Alice);
					let iBellMeasurement0 = rtoi(BellMeasurement[0]);
					let iBellMeasurement1 = rtoi(BellMeasurement[1]);
					Message($"Bell measure result: {BellMeasurement} {iBellMeasurement0} {iBellMeasurement1}");

					Message("Measuring Bob register");
					ApplyToEach(H, Bob);
					if(direction == "Y")
					{
						ApplyToEach(S,Bob);
					}
					let b = MeasureRegister(Bob);
					let iB = rtoi(b);
					Message($"Bob result: {b} {iB}");

					Message("Applying X");
					ApplyCaseX(BellMeasurement[1], Charlie);


					let aXORb = itor(Xor(rtoi(BellMeasurement[0]), rtoi(b)), msgSize);  
					Message("Applying Z");
					ApplyCaseZ(aXORb, Charlie);

					Message("Measuring Charlie register");
					if(basis == "H")
					{
						ApplyToEach(H, Charlie);
					}
					let res = MeasureRegister(Charlie);
					let intRes = rtoi(res);

					
					SetIntToQb(0, register);
					if(intRes != msg)
					{
						Message($"{i} Fault M = {BellMeasurement[0]}, A = {BellMeasurement[1]}, B = {b}, ZControl = {aXORb}");
						set success = false;
					}
					else
					{
						Message($"Final Result: {res} {intRes}");
					}
				}
			}
			return success;
		}
	}
}

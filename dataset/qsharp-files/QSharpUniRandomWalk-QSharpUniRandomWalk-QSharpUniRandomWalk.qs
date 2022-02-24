//Copyright (c) Daniel Strano 2017. All rights reserved.
//Licensed under the GNU General Public License V3.
//See LICENSE.md in the project root or https://www.gnu.org/licenses/gpl-3.0.en.html for details.

//(See Driver.cs for introduction.)

namespace Quantum.QSharpUniRandomWalk
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	operation Set (desired: Result, q1: Qubit) : ()
    {
		//This operation just sets a qubit to the desired pure state.
        body
        {
			//We measure the state, first.
            let current = M(q1);
            if (desired != current)
            {
				//If the result of the measurement isn't the state we want,
				// we flip the qubit with a "not" operation.
                X(q1);
            }
        }
    }

	operation SimulateWalk (mpPowerOfTwo: Int, planckTimes : Int) : Int
    {
		//This operation carries out our full unidirectional quantum random walk simulation.
		//"mpPowerOfTwo" gives the (positive) starting point, equal to 2^mpPowerOfTwo - 1.
		// The destination is always 0.
		//"planckTimes" is how many discrete time steps we will simulate for.
        body
        {	
			//Maximum value for loop control:
			let maxLCV = mpPowerOfTwo - 1;
			//50/50 Superposition between "step" and "don't step" at each discrete time step
			//is equivalent to Pi/4 rotation around the y-axis of spin, each time: 
			let angle = -3.141592653589793 / 4.0;
			//This is our starting distance from the destination point (plus one).
			mutable power = 1;
			for (i in 2..mpPowerOfTwo) {
				set power = power * 2;
			}

			//We will store our ultimate position in this variable and return it from the operation:
			mutable toReturn = 0;

			//This isn't exactly the same as a classical unidirectional discrete random walk.
			//At each step, we superpose our current distance from the destination with a distance
			//that is one unit shorter. This is equivalent to a rotation around the y-axis,
			//"Ry(Pi/4, qubit[0])", where qubit[0] is the least significant qubit of our distance.
			//Four successive steps of superposition then give a rotation of Pi.
			//A rotation of Pi about the y-axis MUST turn a pure state of |0> into a pure state of |1>
			//and vice versa.
			// Hence, we already know a maximum amount of time steps this could take, "power * 4".
			// We can just return zero if our time step count is greater than or equal to this.
			if (planckTimes / 4 < power) {
				//If we haven't exceeded the known maximum time, we carry out the algorithm.
				//We grab enough qubits and set them to the initial state.
				using (qubits = Qubit[mpPowerOfTwo]) {
					for (i in 1..maxLCV) {
						//Weirdly, we use |0> to represent 1 and |1> to represent 0,
						//just so we can avoid many unnecessary "not" gates, "X(...)" operations.
						Set(Zero, qubits[maxLCV]);
					}
					
					mutable workingPower = 1;
					for (i in 1..planckTimes) {
						//For each time step, first increment superposition in the least significant bit:
						Ry(angle, qubits[0]);
						//At 2 steps, we could have a change in the second least significant bit.
						//At 4 steps, we could have a change in the third least significant bit AND the second least.
						//At 8 steps, we could have a change in the fourth least, third least, and second least.
						//(...Etc.)
						set workingPower = 1;
						for (j in 1..maxLCV) {
							set workingPower = workingPower * 2;
							if (i % workingPower == 0) {
								//"CNOT" is a quantum "controlled not" gate.
								//If the control bit is in a 50/50 superposition, for example,
								// the other input bit ends up in 50/50 superposition of being reversed, or "not-ed".
								// The two input bits can become entangled in this process! If the control bit were next
								// immediately measured in the |1> state, we'd know the other input qubit was flipped.
								// If the control bit was next immediately measured in the |0> state, we'd know the other input
								// qubit was not flipped.

								//(Here's where we avoid two unnecessary "not" or "X(...)" gates by flipping our 0/1 convention:)
								CNOT(qubits[j - 1], qubits[j]);
							}
						}
					}

					//The qubits are now in their fully simulated, superposed and entangled end state.
					// Ultimately, we have to measure a final state in the |0>/|1> basis for each bit, breaking the
					// superpositions and entanglements. Quantum measurement is nondeterministic and introduces randomness,
					// so we repeat the simulation many times in the driver code and average the results.
					set power = 1;
					for (j in 0..maxLCV) {
						let res = M(qubits[j]);
						//(Remember that the 0/1 convention is flipped:) 
						if (res == Zero) {
							set toReturn = toReturn + power;
						}
						set power = power * 2;
						//The "operating system" expects us to clean our qubits before releasing them, by setting them to zero.
						Set(Zero, qubits[j]);
					}
				}
			}

			//("Hello, Universe!")
			return toReturn;
        }
    }
}

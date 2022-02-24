namespace Kitaev {
        //Title: Kitaev
	//Author: Nicholas Bohlsen
	//Version: 6.0
	//Date: 26/10/21
	//Description: This source code file includes a Q# implementation of the Kitaev phase estimation procedure. For
	//	       details refer to the paper which is included in the same GitHub repository as this program. 
	
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    

    operation phaseKickbackSubroutine_Odd (U : (Qubit[] => Unit is Adj+Ctl),
                                       	   register : Qubit[],
                                           anc : Qubit,
                                           Mul : Int) : Unit is Adj + Ctl {
        //Performs the phase kickback routine which forms the basis of the Kitaev algorithm.
        //This circuit can observe the sign of the angle
        //Note Mul is an integer describing the multiple of the eigenphase which is to be acquired
        //It is called Mul because M is already used as a base callable in Q#
        
        H(anc);
        
        S(anc); //This is K in Kitaev's conventions
        
        for i in 1 .. Mul {
            Controlled U([anc],register);
        }
        
        H(anc);
    }
    operation phaseKickbackSubroutine_Even (U : (Qubit[] => Unit is Adj+Ctl),
                                            register : Qubit[],
                                            anc : Qubit,
                                            Mul : Int) : Unit is Adj + Ctl {
        //Performs the phase kickback routine which forms the basis of the Kitaev algorithm.
        //This circuit can measure over the full range from 0 to \pi
        //Note M is an integer describing the multiple of the eigenphase which is to be acquired
        
        H(anc);
        
        for i in 1 .. Mul {
            Controlled U([anc],register);
        }
        
        H(anc);
    }
    operation measurementLoopKitaev (U : (Qubit[] => Unit is Adj+Ctl),
                                     eigenstate : Qubit[],
                                     Nruns : Int,
                                     Mul : Int) : Double[]{
        //Peform the measurement-gate loop to determine the statistics of the Kitaev process
        //for the U operator. The count is stored as a double precision float for later convenience.
        //Note Mul is an integer describing the multiple of the eigenphase which is to be acquired
        //It is called Mul because M is already used as a base callable in Q#
        
        mutable count_sin = 0.0; //set up the integer which will store the number of zeros measured for the odd case
        mutable count_cos = 0.0; //set up the integer which will store the number of zeros measured for the even case

        use anc = Qubit(); //set up an ancilliary Qubit

        //Run the loop, and record the number of 0's which are observed
        for k in 1..Nruns {
            phaseKickbackSubroutine_Odd(U,eigenstate,anc,Mul);

            if M(anc) == Zero { set count_sin = count_sin + 1.0;}
            else { X(anc);}
        }
        for k in 1..Nruns {
            phaseKickbackSubroutine_Even(U,eigenstate,anc,Mul);

            if M(anc) == Zero { set count_cos = count_cos + 1.0;}
            else { X(anc);}
        }
        Reset(anc);
        
        return [count_sin,count_cos];
    }
    function compute_phi (count : Double[],Nruns : Int) : Double {
        //Take the count of zeroes from the measurement loop and convert that into 
        //a prediction for the eigenphase.
        let p0_sin = count[0]/IntAsDouble(Nruns);
        let sin_2piPhi = 1.0-2.0*p0_sin;
        let p0_cos = count[1]/IntAsDouble(Nruns);
        let cos_2piPhi = 2.0*p0_cos-1.0;
        
        //We take the signs of the different trig functions to infer which quadrant the eigenphase is in
        if (cos_2piPhi > 0.0) { 
            if (sin_2piPhi >0.0) {
                let phi = ArcTan(sin_2piPhi/cos_2piPhi)/(2.0*PI()); //The arctan gives the best approximation from the sin and cos
                return phi; 
            }
            else {
                let phi = ArcTan(sin_2piPhi/cos_2piPhi)/(2.0*PI());
                return 1.0+phi; 
            }
        } 
        else {
            if (sin_2piPhi > 0.0) {
                let phi = ArcTan(sin_2piPhi/cos_2piPhi)/(2.0*PI());
                return 0.5+phi; 
            }
            else {
                let phi = ArcTan(sin_2piPhi/cos_2piPhi)/(2.0*PI());
                return 0.5+phi; 
            }
        }
    }
    
    operation estimatePhaseKitaev (U : (Qubit[] => Unit is Adj+Ctl),
                                   eigenstate : Qubit[],
                                   Nruns : Int) : Double {
        //Perform the full Kitaev phase estimation procedure for a chosen 
        //number of runs.
        let count = measurementLoopKitaev(U,eigenstate,Nruns,1);
        let phi = compute_phi(count,Nruns);
        return phi;
    }
    operation estimatePhaseKitaev_Bestmp2Bit (U : (Qubit[] => Unit is Adj+Ctl),
                                            eigenstate : Qubit[],
                                            Nruns : Int,
                                            m : Int) : Int[] {
        //Perform the full Kitaev phase estimation procedure for a chosen 
        //number of runs and return the best m+2 bit approximation to the eigenphase.
        //Note that 2mN full measurements will be taken within this operation.
        //This program follows the pseudocode in Svore et al.
        
        //Define some useful arrays
        mutable rho_arr = new Double[m-1];
        mutable phi = 0.0;
        mutable Mul = 1;
        mutable alpha_arr = new Int[m+2]; //This will be a binary array but in Q# it is most convenient as an integer array
        
       //We isolate the binary digits in turn by computing succesive approximations to each power
       //of 2 multiple of the eigenphase.
        for j in 1 .. m-1 {
            set Mul = PowI(2,j-1);
            set phi = compute_phi(measurementLoopKitaev(U,eigenstate,Nruns,Mul),Nruns);
            set rho_arr w/= j-1 <- phi;
        }
        
        //The last few digits must be dealt with separately so we do that here
        let rho_m = compute_phi(measurementLoopKitaev(U,eigenstate,Nruns,PowI(2,m-1)),Nruns);
        mutable best_octant = 0.0;
        for i in 1 .. 7 {//Here we find the octant value i/8 which is closest to rho_m
            if (AbsD(IntAsDouble(i)/8.0-rho_m) < AbsD(best_octant-rho_m)) { 
                set best_octant = IntAsDouble(i)/8.0;
            }
        }
        for alpha_m in 0..1 {//this searches for the correct binary representation of the best_octant choice
            for alpha_mp1 in 0..1 {
                for alpha_mp2 in 0..1 {
                    if (IntAsDouble(alpha_m)*0.5+IntAsDouble(alpha_mp1)*0.25+IntAsDouble(alpha_mp2)*0.125) == best_octant {
                        set alpha_arr w/= m-1 <- alpha_m;
                        set alpha_arr w/= m <- alpha_mp1;
                        set alpha_arr w/= m+1 <- alpha_mp2;
                    }
                }
            }
        }
        
        //We now infer the remaining bits via 
        mutable cache_difference = 0.0;
        mutable l = m;
        for k in 1 .. m-1 {
            set l = m-k;
            set cache_difference = RealMod(AbsD(IntAsDouble(alpha_arr[l])*0.25+IntAsDouble(alpha_arr[l+1])*0.125-rho_arr[l-1]),1.0,0.0);
                                   //ReadMod allows for this real number to be taken mod 1
                                   //The internal argument of the above is the difference between the true multiple of the eigenphase
                                   //and the values possible given the bits already inferred. See Svore et al for details.
            if cache_difference < 0.25 {
                set alpha_arr w/= l-1 <- 0;
            }
            set cache_difference = RealMod(AbsD(0.5+IntAsDouble(alpha_arr[l])*0.25+IntAsDouble(alpha_arr[l+1])*0.125-rho_arr[l-1]),1.0,0.0);
            if cache_difference < 0.25 {
                set alpha_arr w/= l-1 <- 1;
            }
        }
        
        return alpha_arr;
    }
    //The section below is a series of test functions which demonstrate the
    //Kitaev phase estimation process in action for a series of different unitary
    //operators and eigenvectors.
    
    operation TestRZ_Passable (register : Qubit[]) : Unit is Adj + Ctl {
        //Implements the phase rotation gate for a particular rotation angle
        let phi = 0.85;
        let angle = 2.0*PI()*phi;
        Rz(2.0*angle,register[0]);
    }
    operation TestRZ_bitwise() : Int[] {
        //Tests the Kitaev Process for the case of a pure z rotation
        use eigenstate = Qubit();
        X(eigenstate);//sets to the |1> eigenket
        
        let phi = estimatePhaseKitaev_Bestmp2Bit(TestRZ_Passable,[eigenstate],1000,8);//Runs 10000 iterations
        ResetAll([eigenstate]);
        return phi;
    }
    operation TestRZ() : Double {
        //Tests the Kitaev Process for the case of a pure z rotation
        use eigenstate = Qubit();
        X(eigenstate);//sets to the |1> eigenket
        
        let phi = estimatePhaseKitaev(TestRZ_Passable,[eigenstate],10000);//Runs 10000 iterations
        ResetAll([eigenstate]);
        return phi;
    }
    
    
    operation TestS_Passable (register : Qubit[]) : Unit is Adj + Ctl {
        S(register[0]);
    }
    operation TestS0() : Double {
        //Tests the Kitaev Process for the case of the S gate and the |0> ket
        use eigenstate = Qubit();
        
        let phi = estimatePhaseKitaev(TestS_Passable,[eigenstate],10000);//Runs 10000 iterations
        ResetAll([eigenstate]);
        return phi;
    }
    operation TestS1() : Double {
        //Tests the Kitaev Process for the case of the S gate and the |1> ket
        use eigenstate = Qubit();
        X(eigenstate);//sets to the |1> eigenket
        
        let phi = estimatePhaseKitaev(TestS_Passable,[eigenstate],10000);//Runs 10000 iterations
        ResetAll([eigenstate]);
        return phi;
    }
    
    
    operation TestH_Passable (register : Qubit[]) : Unit is Adj + Ctl {
        H(register[0]);
    }
    operation TestH() : Double {
        //Tests the Kitaev Process for the case of the H gate and its +1 eigenket
        use eigenstate = Qubit();
        let theta = 2.0*ArcCos((1.0+Sqrt(2.0))/Sqrt(4.0+2.0*Sqrt(2.0))); //Rotates the state to the +1 eigenket
        Ry(theta,eigenstate);
        
        let phi = estimatePhaseKitaev(TestH_Passable,[eigenstate],10000);//Runs 10000 iterations
        ResetAll([eigenstate]);
        return phi;
    }
    
    
    //The program below performs the Rz test but with many different run counts
    //This is designed to allow me to analyse the scaling of the error with the
    //number of iterations used in Kitaev's algortihm. 
    
    operation TestScaling_RZ() : Double[] {
        //Tests the Kitaev Process for the case of a pure z rotation
	//WARNING!!!!!!!
		//This is a stress test program and is VERY VERY long. 
		//It can take upwards of 3.5 hours to complete and 
		//was only included for completeness as it is a piece of experimental code used by the developer.

        use eigenstate = Qubit();
        X(eigenstate);//sets to the |1> eigenket
        
        let Nrun_arr = [1,5,
                        10,50,
                        100,500,
                        1000,5000,
                        10000,50000,
                        100000,500000,
                        1000000,5000000];
        
        mutable phi_arr = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,
                           0.0,0.0,0.0,0.0,0.0,0.0,0.0];
            
        for n in 0..13 { set phi_arr w/= n <- estimatePhaseKitaev(TestRZ_Passable,[eigenstate],Nrun_arr[n]);}
        ResetAll([eigenstate]);
        return phi_arr;
    }
    
    operation TestScaling_H() : Double[] {
        //Tests the Kitaev Process for the case of a pure H gate
	//WARNING!!!!!!!
		//This is a stress test program and is VERY VERY long. 
		//It can take upwards of 3.5 hours to complete and 
		//was only included for completeness as it is a piece of experimental code used by the developer.

        use eigenstate = Qubit();
        let theta = 2.0*ArcCos((1.0+Sqrt(2.0))/Sqrt(4.0+2.0*Sqrt(2.0)));
        Ry(theta,eigenstate);
        
        let Nrun_arr = [1,5,
                        10,50,
                        100,500,
                        1000,5000,
                        10000,50000,
                        100000,500000];
        
        mutable phi_arr = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,
                           0.0,0.0,0.0,0.0,0.0];
            
        for n in 0..11 { set phi_arr w/= n <- estimatePhaseKitaev(TestH_Passable,[eigenstate],Nrun_arr[n]);}
        ResetAll([eigenstate]);
        return phi_arr;
    }
    
    
    operation Import_check() : String {
       return "Kitaev module correctly compiled and successfully imported"; 
    }
}

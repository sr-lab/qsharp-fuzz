namespace Qrng {
   open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Measurement;

    operation RandomBit() : Int{
        using (q = Qubit()){ 
            H(q); 
            if(MResetZ(q) == One){
                return 1;
            }
            else{
                return 0;
            }
        }
    }

operation KeyBB84(AliceBits : Int[], AliceBase : Int[], BobBase : Int[], tamanho : Int) : Int[]{

        using( qubits = Qubit[tamanho] ) 
        {
    
            AplicaAlice(qubits, tamanho, AliceBits, AliceBase);

            mutable BobMedida = LeituraBob(qubits, tamanho, BobBase);
            mutable BobBits = ConvertResultinIntArray(BobMedida, tamanho);

            mutable key = new Int[tamanho];
            mutable t = 0;
            for(i in 0..tamanho-1){
                if(AliceBase[i] == BobBase[i]){
                    set key w/= t <- AliceBits[i];
                    set t = t + 1;
                }
            }
            
            ResetAll(qubits);
            return key[0..t-1]; 

        }

    }

    operation AplicaAlice(qubits : Qubit[], tamanho : Int, AliceBits : Int[], AliceBase : Int[]) : Unit{
        for(i in 0..tamanho-1){
            if(AliceBits[i] == 1){ X(qubits[i]); } 
            if(AliceBase[i] == 1){ H(qubits[i]); } 
        }
    }

    operation LeituraBob(qubits : Qubit[], tamanho : Int, BobBase : Int[]) : Result[]{  
       
        mutable MedidaBob = new Result[tamanho];
        for(i in 0..tamanho-1){
            if(BobBase[i] == 1){ H(qubits[i]); }
            set MedidaBob w/= i <- M(qubits[i]); 
        }
        return MedidaBob;
    }

    operation ConvertResultinIntArray(BobMedida : Result[], tamanho : Int) : Int[]{
        mutable arr = new Int[tamanho];
        for(i in 0..tamanho-1){
            if(BobMedida[i]==One){
                set arr w/= i <- 1;
            }else{
                set arr w/= i <- 0;
            }
        }
        return arr;
    }
}
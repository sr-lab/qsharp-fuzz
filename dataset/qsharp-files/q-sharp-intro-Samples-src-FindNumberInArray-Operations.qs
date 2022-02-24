namespace Quantum.QSharpApplication4
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    operation HelloWorld () : Unit {
        Message("Hello quantum world!");
    }

	operation IsPrimeNumber(number : Int) : Int {
		body {
			mutable isPrime = 0;
			if ( number % 2 == 0 ) {
				set isPrime = 1;
			}
			return (isPrime);
		}
	}

	
	operation IsNumberInArr(array : Int[], number : Int) : Bool {
		body {
			mutable exists = false;

			for(i in array) {
				if ( i == number ) {
					set exists = true;
				}
			}

			return (exists);
		}
	}

}

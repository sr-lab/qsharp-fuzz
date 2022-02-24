namespace Quantum.QSharpApplication
{
    open Microsoft.Quantum.Primitive;
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

}

namespace Superposition { open Microsoft.Quantum.Canon; open Microsoft.Quantum.Convert; open Microsoft.Quantum.Intrinsic; @EntryPoint() operation Hello () : Unit { Message("Hello quantum world!"); H(q); let b = M(q); Message( BoolAsString( b == One ) ); Reset(q); } } }
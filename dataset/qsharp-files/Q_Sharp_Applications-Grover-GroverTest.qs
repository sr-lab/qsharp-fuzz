namespace Quantum.Grover
{
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Core;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	operation Uf (x: Qubit[], y: Qubit, z: Int) : () 
    {
        body
  	    {
	        mutable a=z;
			for(i in 0..Length(x)-1)
			{
			    if(a%2==0)
				{
				    X(x[Length(x)-1-i]);
				}
			    set a=a/2;
			}
			Controlled X(x, y);		
			set a=z;
			for(i in 0..Length(x)-1)
			{
			    if(a%2==0)
				{
				    X(x[Length(x)-1-i]);
				}
			    set a=a/2;
			}
	    }
    }
    
    operation GroverTest(n: Int): (Int, Int, Result[] )
    {
	    body
		{
		    mutable r=RandomIntPow2(n);
			mutable s=new Result[n];
			mutable m=1;
			for(i in 1..n/2)
			{
				set m=m*2;
			}
			if(n%2==1)
			{
				set m=m*7/5;
			}
			using (x = Qubit[n])
			{
			    ResetAll(x);
				for(i in 0..n-1)
				{
					H(x[i]);
				}
				using (y = Qubit[1])
				{
				    Reset(y[0]);
					X(y[0]);
					H(y[0]);
					for(j in 1..m-1)
					{
					    Uf(x,y[0],r);
						for(i in 0..n-1)
						{
							H(x[i]);
						}
						for(i in 0..n-1)
						{
							X(x[i]);
						}
						H(x[n-1]);
						Controlled X(x[0..n-2], x[n-1]);	
						H(x[n-1]);
						for(i in 0..n-1)
						{
							X(x[i]);
						}
						for(i in 0..n-1)
						{
							H(x[i]);
						}
					}
					Reset(y[0]);
				}
				for(i in 0..n-1)
				{
					set s[i]=M(x[i]);
				}
				ResetAll(x);
			}
			mutable p=0;
			for(i in 0..n-1)
			{
			    set p=p*2;
				if(s[i]==One)
				{
					set p=p+1;
				}
			}
			return (r,p,s);
		}
	}
}

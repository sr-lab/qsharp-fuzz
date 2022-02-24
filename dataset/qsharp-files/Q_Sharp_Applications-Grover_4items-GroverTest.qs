namespace Quantum.Grover_4items
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    
    operation Uf (x: Qubit[], y: Qubit, z: Int) : () 
    {
        body
  	{
	    if(z/2==0)
	    {
		X(x[0]);
	    }
	    if(z%2==0)
	    {
		X(x[1]);
	    }
	    //(Controlled X)([x[0];x[1]],y);
	    CCNOT(x[0],x[1],y);
	    if(z/2==0)
	    {
		X(x[0]);
	    }
	    if(z%2==0)
	    {
		X(x[1]);
	    }
	}
    }

    operation GroverTest(): (Int, Result, Result)
    {
	body
	{
		mutable r=RandomInt(4);
		mutable s1=Zero;
		mutable s2=Zero;
		using (x=Qubit[2])
		{
			ResetAll(x);
			for(i in 0..Length(x)-1)
			{
	        		H(x[i]);
         		}
			using(y=Qubit[1])
			{
			    Reset(y[0]);
		            X(y[0]);
         		    H(y[0]);
			    Uf(x,y[0],r);
			    Reset(y[0]);
			}
			for(i in 0..Length(x)-1)
			{
				H(x[i]);
			}
			for(i in 0..Length(x)-1)
			{
				X(x[i]);
			}
			H(x[1]);
			CNOT(x[0],x[1]);
			H(x[1]);
			for(i in 0..Length(x)-1)
			{
				X(x[i]);
			}
			for(i in 0..Length(x)-1)
			{
				H(x[i]);
			}
			set s1=M(x[0]);
			set s2=M(x[1]); 
			ResetAll(x);
		}
		return (r,s1,s2);
	}
    }
}

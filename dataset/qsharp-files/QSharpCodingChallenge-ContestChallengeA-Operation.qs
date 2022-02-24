namespace Quantum.ContestChallengeA
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Operation (qs : Qubit[]) : ()
    {
        body
        {
            ApplyToEach(H, qs);
        }
    }
}

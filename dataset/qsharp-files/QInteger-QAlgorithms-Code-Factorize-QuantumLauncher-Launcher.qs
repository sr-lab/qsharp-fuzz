namespace Factorize.Quantum.Launcher
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open QAlgorithms.Shor;

    operation Launcher(a : Int, Mod : Int) : Int
    {
        return ShorOrderFinder(a, Mod);
	}
}

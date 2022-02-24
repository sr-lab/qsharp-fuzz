namespace Test {
    open Pseudorandom;
    open Microsoft.Quantum.Intrinsic;

    @EntryPoint()
    operation Run() : Int {
        for _ in 1..9999 {
            Message($"{DrawRandomInt(1, 10)}");
        }
        return DrawRandomInt(1, 10);
    }
}


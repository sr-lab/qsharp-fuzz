// Hello World in a Quantum Q# Language
// Author: Arthur Eugenio Silverio
// Data: 12/08/2021
// (C) 2021 Arthur Eugenio Silverio
// This file is released under the Simplified BSD License (see LICENSE)

namespace Quantum.HelloWorld {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    @EntryPoint()
    operation Hello () : Unit {
        Message("Hello Quantum World!");
    }
}

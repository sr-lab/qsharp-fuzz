// ====================================
//
//        Title: Hello World
//       Author: Chetanya Kunndra
//         Date: 26 Dec 2020
//       Github: @Ck1998 
//
// ====================================


namespace quantum_hello_world
{
    // Importing libraries
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    // Operation is used to create function just like
    // def in python 
    // void () in c, c++
    // Syntac operation <function name>(): <return type>
    // 'Unit' return type means the this function won't return
    // amy values.
    // similar to 'void' datatype in c, c++, java 
    @EntryPoint()
    operation hello(): Unit
    {
        // Print to screen
        // same as printf in c, 
        // print in python 
        // System.out.Println in java
        Message("Hello World, from my first quantum code.");
    }
}
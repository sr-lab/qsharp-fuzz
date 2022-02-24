 namespace Microsoft.Quantum.Testing.QIR.Other { open Microsoft.Quantum.Bitwise; open Microsoft.Quantum.Convert; @EntryPoint() function PauliArrayAsIntTest() : Int { if 0 != PauliArrayAsInt([PauliI]) { return 1; } if 1 != PauliArrayAsInt([PauliX]) { return 1; } if 3 != PauliArrayAsInt([PauliY]) { return 3; } if 2 != PauliArrayAsInt([PauliZ]) { return 4; } if 0x2310 != PauliArrayAsInt( [PauliI, PauliI, PauliX, PauliI, PauliY, PauliI, PauliZ, PauliI]) { return 5; } if 0 != PauliArrayAsInt(new Pauli[31]) { return 6; } if 0x3000000000000000 != PauliArrayAsInt(new Pauli[31] w/ 30 <- PauliY) { return 7; } return 0; } @EntryPoint() function PauliArrayAsIntFailTest() : Int { return PauliArrayAsInt(new Pauli[32]); } @EntryPoint() function ParityTest() : Int { if 0 != Parity(0) { return 1; } if 1 != Parity(1) { return 2; } if 1 != Parity(2) { return 3; } if 0 != Parity(3) { return 4; } if 0 != Parity(0xFF) { return 5; } if 1 != Parity(0x100) { return 6; } if 0 != Parity(0xFFFF) { return 7; } if 1 != Parity(0x10000) { return 8; } if 1 != Parity(0x7F00000000000000) { return 9; } if 0 != Parity(0x0F00000000000000) { return 10; } if 0 != Parity(-1) { return 11; } if 1 != Parity(-2) { return 12; } return 0; } } 
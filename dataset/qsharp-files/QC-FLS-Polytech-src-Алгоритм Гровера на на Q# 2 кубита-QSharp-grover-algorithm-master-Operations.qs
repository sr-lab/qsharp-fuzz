namespace Microsoft.Quantum.Samples.SimpleGrover {
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;

    /// # Summary
    /// This operation applies Grover's algorithm to search all possible inputs
    /// to an operation to find a particular marked state.
    /// # Краткое изложение
    /// Эта операция применяет алгоритм Гровера для поиска всех возможных входов 
    /// в операции, чтобы найти определенное отмеченное состояние.
    operation SearchForMarkedInput(nQubits : Int) : Result[] {
        using (qubits = Qubit[nQubits]) {
            // Initialize a uniform superposition over all possible inputs.
            // Инициализируйте равномерную суперпозицию по всем возможным входам.
            PrepareUniform(qubits);
            // The search itself consists of repeatedly reflecting about the
            // marked state and our start state, which we can write out in Q#
            // as a for loop.
            // Сам поиск состоит из многократного размышления о помеченном состоянии 
            // и нашем начальном состоянии, которое мы можем записать в Q # как цикл for.
            for (idxIteration in 0..NIterations(nQubits) - 1) {
                ReflectAboutMarked(qubits);
                ReflectAboutUniform(qubits);
            }
            // Measure and return the answer.
            // Измерьте и верните ответ.
            return ForEach(MResetZ, qubits);
        }
    }

    /// # Summary
    /// Returns the number of Grover iterations needed to find a single marked
    /// item, given the number of qubits in a register.
    /// #Краткое изложение
    /// Возвращает количество итераций Гровера, необходимое для поиска 
    /// одного отмеченного элемента, учитывая количество кубитов в регистре.
    function NIterations(nQubits : Int) : Int {
        let nItems = 1 <<< nQubits; // 2^numQubits
        // compute number of iterations:
        // вычислить количество итераций:
        let angle = ArcSin(1. / Sqrt(IntAsDouble(nItems)));
        let nIterations = Round(0.25 * PI() / angle - 0.5);
        return nIterations;
    }

}
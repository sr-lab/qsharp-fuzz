namespace Microsoft.Quantum.Samples.SimpleGrover {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;

    /// # Summary  
    /// Reflects about the basis state marked by alternating zeros and ones.
    /// This operation defines what input we are trying to find in the main
    /// search.
    /// # Краткое изложение
    /// Размышляет об основном состоянии, отмеченном чередующимися нулями и единицами. 
    /// Эта операция определяет, какой ввод мы пытаемся найти в основном поиске.
    operation ReflectAboutMarked(inputQubits : Qubit[]) : Unit {
        Message("Reflecting about marked state...");
        using (outputQubit = Qubit()) {
            within {
                // We initialize the outputQubit to (|0⟩ - |1⟩) / √2,
                // so that toggling it results in a (-1) phase.
                // Мы инициализируем outputQubit как (| 0⟩ - | 1⟩) / √2, 
                // так что переключение его приводит к фазе (-1).
                X(outputQubit);
                H(outputQubit);
                // Flip the outputQubit for marked states.
                // Here, we get the state with alternating 0s and 1s by using
                // the X instruction on every other qubit.
                // Переверните outputQubit для отмеченных состояний. 
                // Здесь мы получаем состояние с чередованием 0 и 1, используя инструкцию X
                // на каждом другом кубите.
                ApplyToEachA(X, inputQubits[...5...]);
            } apply {
                Controlled X(inputQubits, outputQubit);
            }
        }
    }

    /// # Summary
    /// Reflects about the uniform superposition state.
    /// # Краткое изложение
    /// Размышляет о состоянии равномерной суперпозиции.
    operation ReflectAboutUniform(inputQubits : Qubit[]) : Unit {
        within {
            // Transform the uniform superposition to all-zero.
            // Преобразуйте равномерную суперпозицию в ноль.
            Adjoint PrepareUniform(inputQubits);
            // Transform the all-zero state to all-ones
            // Преобразование состояния «все ноль» во все единицы
            PrepareAllOnes(inputQubits);
        } apply {
            // Now that we've transformed the uniform superposition to the
            // all-ones state, reflect about the all-ones state, then let
            // the within/apply block transform us back.
            // Теперь, когда мы преобразовали равномерную суперпозицию 
            // в состояние «все единицы», поразмышляем о состоянии «все единицы»,
            // а затем позволим блоку inside / apply преобразовать нас обратно.
            ReflectAboutAllOnes(inputQubits);
        }
    }

    /// # Summary
    /// Reflects about the all-ones state.
    /// # Краткое изложение
    /// Размышляет во все единицы.
    operation ReflectAboutAllOnes(inputQubits : Qubit[]) : Unit {
        Controlled Z(Most(inputQubits), Tail(inputQubits));
    }

    /// # Summary
    /// Given a register in the all-zeros state, prepares a uniform
    /// superposition over all basis states.
    /// #Краткое изложение
    /// Учитывая регистр в состоянии всех нулей, готовит равномерную 
    /// суперпозицию по всем базовым состояниям.
    operation PrepareUniform(inputQubits : Qubit[]) : Unit is Adj + Ctl {
        ApplyToEachCA(H, inputQubits);
    }

    /// # Summary
    /// Given a register in the all-zeros state, prepares an all-ones state
    /// by flipping every qubit.
    /// # Краткое изложение
    /// Имея регистр в состоянии «все нули», готовит состояние «все единицы»,
    /// переворачивая каждый кубит.
    operation PrepareAllOnes(inputQubits : Qubit[]) : Unit is Adj + Ctl {
        ApplyToEachCA(X, inputQubits);
    }

}
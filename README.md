# mapReduce
Repositório para o desenvolvimento do projeto 3 da disciplina de Programação Funcional

## Observações úteis:

* Método Erlang para retornar o número de cores lógicos da CPU:

    > :erlang.system_info(:logical_processors_available)

* Implementação com exemplo de uso:

```
defmodule Cpu do
  def num_cores do
    :erlang.system_info(:logical_processors_available)
  end
end

IO.puts("O número de cores lógicos da CPU é: #{Cpu.num_cores()}")
```

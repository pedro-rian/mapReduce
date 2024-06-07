defmodule Mapreduce do

  def ler(arquivo \\ "dados.txt") do
    arquivo |> File.read |> elem(1) |> String.replace(".","") |> String.replace(",","") |> String.split(" ")
  end

  def partitioning(enumerable, tasks) do
    size = div(Enum.count(enumerable), tasks)
    partitioning(enumerable, tasks, size, 0)
  end

  defp partitioning(enumerable, tasks, size, cont) when cont < tasks do
    [Task.async(fn -> listToMap(enumerable)|> Enum.slice(cont * size, size ) |> agrupar  end)] ++
      partitioning(enumerable, tasks, size, cont + 1)
  end

  defp partitioning(_, _, _, _) do
    []
  end


  def runtask([]) do
    []
  end

  def runtask([h|t]) do
    Task.await(h) ++ runtask(t)
  end


  def listToMap([]) do
    []
  end

  def listToMap([h|t]) do
    [%{chave: h, valor: 1}] ++ listToMap(t)
  end

  def exemplo() do
    lista = [
      %{chave: "a", valor: 1},
      %{chave: "b", valor: 2},
      %{chave: "a", valor: 3},
      %{chave: "c", valor: 4},
      %{chave: "b", valor: 5}
    ]

    #Para agrupar os mapas com chaves iguais
    agrupados = Enum.group_by(lista, &(&1.chave))

    #Depois disso, se você quiser juntar os mapas dentro de cada grupo
    Enum.map(agrupados, fn {chave, mapas} -> {chave, soma(mapas)} end)

  end

  def agrupar(map) do
    map
      |>Enum.group_by(&(&1.chave))
      |>Enum.map(fn {chave, mapas} -> {chave, soma(mapas)} end)
  end

  #Aqui, soma é uma função que você precisa definir para juntar
  #os mapas com chaves iguais.
  def soma(mapas) do
    Enum.reduce(mapas, %{}, fn mapa, acc ->
      Map.update(acc, :valor, mapa[:valor], &(&1 + mapa[:valor]))
    end)
  end

  def result() do
    input = Mapreduce.ler
    tasks = partitioning(input, 8)
    IO.inspect(tasks)
    map_results = runtask(tasks)
    IO.inspect(map_results)
    System.halt(0)
  end


end

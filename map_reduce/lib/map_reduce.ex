defmodule Utils do

  def ler(arquivo \\ "dados.txt") do
    arquivo
      |> File.read
      |> elem(1)
      |> String.replace(".","")
      |> String.replace(",","")
      |> String.split(" ")
      |> input
  end

  def input(dados)  do
    Enum.map(dados, fn x -> {String.to_atom(x),1} end)
  end

	def partitioning(enumerable, tasks) do
		size = Enum.count(enumerable)/tasks
		size = trunc(Float.ceil(size))
		partitioning(enumerable, tasks, size, 0)
	end
	defp partitioning(enumerable, tasks, size, cont) when cont < tasks do
    IO.inspect(Enum.slice(enumerable, cont*size, size))
		[Task.async(Enum, :slice, [enumerable, cont*size, size])] ++ partitioning(enumerable, tasks, size, cont+1)
	end

	defp partitioning(_, _, _, _) do
		[]
	end
	def receiveMessages do
		receive do

		end
	end
	def runTasks([]), do: nil

	def runTasks(tasks) do
		[Task.await(hd(tasks))] ++ runTasks(tl(tasks))
	end
	def rePartitioning(list) do
		keys = listKeys(list)
		_rePartitioning(keys, list)
	end
	def _rePartitioning([], list) do
		list
	end
	def _rePartitioning(keys, list) do
		list = Keyword.replace(list, hd(keys), mergeValues(hd(keys), list))
		_rePartitioning(tl(keys), list)
	end

	def listKeys(list) do
		keys = Keyword.keys(list)
		_listKeys(list, keys, [])
	end

	def _listKeys(_, emptyList, knownKeys) when emptyList == [] do
		knownKeys
	end
	def _listKeys(keys, key, knownKeys) do
		removeKey = Keyword.delete_first(keys, hd(key))
		if Keyword.get(removeKey, hd(key)) != nil do
			_listKeys(tl(keys), tl(key), knownKeys)
		else
			_listKeys(tl(keys), tl(key), knownKeys ++ [hd(key)])
		end
	end

	def mergeValues(key, list) do
		Keyword.get_values(list, key)
	end

	def at(list, index) do
		at(list, index, 0)
	end

	def at(list, index, cont) do
		if cont == index do
			hd(list)
		else
			at(tl(list), index, cont+1)
		end
	end

  def somar(dados) do
    for {chave, lista} <- dados do
      {chave, Enum.sum(lista)}
    end
  end

end

dados = Utils.ler
IO.inspect(Utils.rePartitioning(dados)|> Utils.somar)
System.halt(0)

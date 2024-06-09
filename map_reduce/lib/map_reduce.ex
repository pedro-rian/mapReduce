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
    size = Enum.count(enumerable)
		partitioning(enumerable, tasks, size, 0)
	end
	defp partitioning(enumerable, tasks, size, cont) when cont < tasks do
		#IO.inspect(Enum.slice(enumerable, cont*size, size))
		#res = spawn(Enum, :slice, [enumerable, cont*size, size])
		#task =
		#IO.inspect(res)
		#IO.puts(enumerable)
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
		#IO.inspect(Task.await(hd(tasks)))
		[Task.await(hd(tasks))] ++ runTasks(tl(tasks))

	end
	def rePartitioning(list) do
		keys = listKeys(list)
		#mergeValues(hd(keys), list)
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

#input = Enum.to_list(100000..19300000)

#tasks = Utils.partitioning(input, 8, 19200000)

#IO.inspect(tasks)

#resp = Utils.runTasks(tasks)

#a = [1, 2, 3, 4, 5, 6]


#b = [a: 1, b: 2, c: 3, d: 4, a: 10, b: 20, c: 30, d: 40]
#IO.inspect(Keyword.keys(b))
#IO.inspect(hd(b))
#IO.inspect(Utils.listKeys(b))

#Lembrar de descomentar abaixo
dados = Utils.ler
IO.inspect(Utils.rePartitioning(dados)|> Utils.somar)

#IO.inspect(Utils.isInside(1, a))

#IO.inspect("first")

#Lembrar de descomentar abaixo
System.halt(0)

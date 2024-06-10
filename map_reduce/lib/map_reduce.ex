defmodule Utils do

  def ler(arquivo \\ "dados.txt") do
    arquivo
      |> File.read
      |> elem(1)
      |> String.replace(".","")
      |> String.replace(",","")
      |> String.split(" ")
  end

	def partitioning(enumerable, tasks, function) do
		size = Enum.count(enumerable)/tasks
		size = trunc(Float.ceil(size))
		partitioning(enumerable, tasks, size, 0, function)
	end
	defp partitioning(enumerable, tasks, size, cont, function) when cont < tasks do
		dados = Enum.slice(enumerable, cont*size, size)
		[Task.async(Enum, :map, [dados, function])] ++ partitioning(enumerable, tasks, size, cont+1, function)
	end

	defp partitioning(_, _, _, _, _) do
		[]
	end

	def runTasks([]) do
		[]
	end

	def runTasks(tasks) do
		Task.await(hd(tasks)) ++ runTasks(tl(tasks))
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

  def partitioningReduce(enumerable, function) do
		#size = Enum.count(enumerable)/tasks
		#size = trunc(Float.ceil(size))
		_partitioningReduce(enumerable, function)
	end

  defp _partitioningReduce(enumerable, _) when enumerable == [] do
		[]
	end

	defp _partitioningReduce(enumerable, function) do
		#IO.inspect(enumerable)
		#dados = Enum.slice(enumerable, cont*size, size)
		#IO.inspect(dados)
		#if dados != [] do
		dados = hd(enumerable)
		[Task.async(fn -> function.(dados) end)] ++ partitioningReduce(tl(enumerable), function)
		#else
		#	partitioningReduce(enumerable, tasks, size, cont+1, function)
		#end
	end

	def runTasksReduce([]) do
		[]
	end

	def runTasksReduce(tasks) do
		#IO.inspect([Task.await(hd(tasks))])
		[Task.await(hd(tasks))] ++ runTasksReduce(tl(tasks))
	end

end
mapFunction = fn x -> {String.to_atom(x),1} end
dados = Utils.ler
#IO.inspect(Utils.rePartitioning(dados)|> Utils.somar)
tasks = Utils.partitioning(dados, 8, mapFunction)
results = Utils.runTasks(tasks)
rep = Utils.rePartitioning(results)
reduceFunction = fn {chave, x} -> {chave, Enum.sum(x)} end
reduceTasks = Utils.partitioningReduce(rep, reduceFunction)
IO.inspect(Utils.runTasksReduce(reduceTasks))
System.halt(0)

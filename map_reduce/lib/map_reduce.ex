defmodule Utils do
  def partitioning(enumerable, tasks) do
    size = div(Enum.count(enumerable), tasks)
    partitioning(enumerable, tasks, size, 0)
  end

  defp partitioning(enumerable, tasks, size, cont) when cont < tasks do
    [Task.async(Enum, :slice, [enumerable, cont * size, size])] ++
      partitioning(enumerable, tasks, size, cont + 1)
  end

  defp partitioning(_, _, _, _) do
    []
  end

  def runTasks([]), do: []

  def runTasks(tasks) do
    [Task.await(hd(tasks))] ++ runTasks(tl(tasks))
  end

  def reduce(results) do
    Enum.reduce(results, %{}, fn chunk, acc ->
      Enum.reduce(chunk, acc, fn elem, acc ->
        Map.update(acc, elem, 1, &(&1 + 1))
      end)
    end)
  end
end

input = Enum.to_list(100_000..193_000)
tasks = Utils.partitioning(input, 8)
IO.inspect(tasks)
map_results = Utils.runTasks(tasks)
IO.inspect(map_results)
reduce_result = Utils.reduce(map_results)
IO.inspect(reduce_result)
System.halt(0)

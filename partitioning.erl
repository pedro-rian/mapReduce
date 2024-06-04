defmodule Utils do
	def partitioning(enumerable, tasks, size) do
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
end

input = Enum.to_list(100000..19300000)

tasks = Utils.partitioning(input, 8, 19200000)

IO.inspect(tasks)

resp = Utils.runTasks(tasks)

#IO.inspect(hd(resp))

System.halt(0)

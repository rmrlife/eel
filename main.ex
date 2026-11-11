Code.require_file("bin.ex",__DIR__)

defmodule CLI do
  def checkexe(name, args) do
    executable =
      if String.contains?(name,"/") do
        Path.expand(name)
      else
        System.find_executable(name)
      end

      case executable do
        nil ->
          IO.puts("#{name}: not found")
          127

        path ->
          try do
            {output, status} = System.cmd(path, args, stderr_to_stdout: true)
            IO.write(output)
            status
          rescue
            _e in Erlang.Error ->
              IO.puts("#{name}: execution failed")
              126
          end
      end

  end

  defp repl do
    IO.write("$ ")
    case IO.gets("") do
      :eof ->
        IO.puts("error: end of file")
        :eof

      cmd ->
        cmd = String.trim(cmd)
          case cmd do
            "" ->
              :ok

            _ ->
              [name | args] = String.split(cmd)
              functions = Ebin.__info__(:functions)
              match = Enum.find(functions, fn {func,arity} -> Atom.to_string(func) =~ name and arity == 1 end) # i need to test for substring collisions

              case match do
                {func,_arity} ->
                  apply(Ebin,func,[args])
                nil ->
                  checkexe(name,args)
              end
              :ok
        end
    end

  end

  def main(_args) do
    case repl() do
      :eof -> System.halt(1)
      :exit -> System.halt(0)
      :ok -> main([]) # legally mandated recursive main function
    end
  end
end
CLI.main([])

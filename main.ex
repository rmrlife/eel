Code.require_file("bin.ex",__DIR__)

defmodule CLI do
  defp repl do
    IO.write("$ ")
    case IO.gets("") do
      :eof ->
        IO.puts("error: end of file")
        :eof

      cmd ->
        cmd = String.trim(cmd)
          case cmd do
            "exit" -> 
              :exit

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
                  IO.puts("#{name}: command not found")
              end
              :ok
        end 
    end

  end

  def main(_args) do
    case repl() do
      :eof -> System.halt(0)
      :exit -> System.halt(0)
      :ok -> main([]) # legally mandated recursive main function
    end
  end
end
#CLI.main([])

defmodule Ebin do
  def echo(args) do
    IO.puts(Enum.join(args, " "))
  end

  def exit(_args) do
    System.halt(0)
  end

  def type(args) do
      [name | _ ] = args
     functions = __MODULE__.__info__(:functions)
     match = Enum.find(functions, fn {func,arity} -> Atom.to_string(func) =~ name and arity == 1 end)

     case match do
      {func, _arity} ->
        IO.puts("#{func} is a shell builtin")

      nil ->
        case System.find_executable(name) do
         nil ->
            IO.puts("#{name}: not found")
         path ->
            IO.puts("#{name} is #{path}")
        end
     end
  end

  # to implement: -
  def pwd(_args) do
    IO.puts(File.cwd!())
  end

  def cd(args) do
    case args do
      ["~"] ->
        File.cd(System.user_home!())

      [path] ->
        path =
        if String.starts_with?(path, "~/") do
          String.replace_prefix(path, "~", System.user_home!())
        else
          path
        end

        case File.cd(path) do
          :ok ->
            :ok

         {:error, reason} ->
            IO.puts("cd: #{path}: #{:file.format_error(reason)}")
          end

      [] ->
        File.cd(System.user_home!())
      _ ->
        IO.puts("cd: too many arguments")
    end
  end
end

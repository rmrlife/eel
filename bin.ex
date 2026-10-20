defmodule Ebin do
  def echo(args) do
    IO.puts(Enum.join(args, " "))
  end
  
  def exit() do
    :exit
  end

  def type(cmd) do
      
  end
end

defmodule Ebin do
  def echo(args) do
    IO.puts(Enum.join(args, " "))
  end

  def exit(_args) do
    :exit
  end

  def type(args) do

  end
end

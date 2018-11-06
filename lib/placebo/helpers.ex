defmodule Placebo.Helpers do
  def failure_message(module, function, args) do
    "Mock Verification Failed: #{output(module, function, args)}\nActual calls to Mock:\n#{format_history(module)}"
  end

  defp output(module, function, args) do
    args_output = args |> Enum.map(&inspect/1) |> Enum.join(", ")
    "#{module}.#{function}(#{args_output})"
  end

  def format_history(module) do
    :meck.history(module)
    |> Enum.map(fn {_pid, {m, f, a}, _ret} ->
      "\t#{m}.#{to_string(f)}(#{inspect(a)})"
    end)
    |> Enum.join("\n")
  end

  def called?(module, function, args, validator) do
    case validator do
      {:times, n} -> n == :meck.num_calls(module, function, args)
      _ -> :meck.called(module, function, args)
    end
  end
end

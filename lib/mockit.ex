defmodule Mockit do

  defmacro __using__(_args) do
    quote do
      import Mockit
      import Mockit.RetSpecs
      import Mockit.Validators

      setup_all do
        Agent.start(fn -> MapSet.new end, name: Mockit.Agent)

        on_exit fn -> Agent.stop(Mockit.Agent) end
        :ok
      end

      setup do
        on_exit &Mockit.Helpers.cleanup/0
        :ok
      end

    end
  end

  defmacro capture({ {:., _, [ module , f ]} , _, args }, arg_num) do
    quote do
      :meck.capture(:first, unquote(module), unquote(f), unquote(args), unquote(arg_num))
    end
  end

  defmacro capture(history_position, { {:., _, [ module , f ]} , _, args }, arg_num) do
    quote do
      :meck.capture(unquote(history_position), unquote(module), unquote(f), unquote(args), unquote(arg_num))
    end
  end

  defmacro allow({ {:., _, [ module , f ]} , _, args }, opts \\ []) do
    quote do
      {Mockit.ReturnTo, unquote(module), unquote(f), unquote(args), unquote(opts)}
    end
  end

  defmacro assert_called({ {:., _, [ module , f ]} , _, args }, validator \\ :any) do
    quote bind_quoted: [module: module, f: f, args: args, validator: validator] do
      result = case validator do
        {:times, n} -> n == :meck.num_calls(module, f, args)
        _ -> :meck.called(module, f, args)
      end
      assert result, Mockit.Helpers.format_history(module)
    end
  end

  defmacro refute_called({ {:., _, [ module , f ]} , _, args }, validator \\ :any) do
    quote bind_quoted: [module: module, f: f, args: args, validator: validator] do
      result = case validator do
        {:times, n} -> n == :meck.num_calls(module, f, args)
        _ -> :meck.called(module, f, args)
      end
      refute result, Mockit.Helpers.format_history(module)
    end
  end

end

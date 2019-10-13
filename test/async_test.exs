defmodule Placebo.Async.Test1 do
  use ExUnit.Case, async: true
  use Placebo
  require Logger

  test "async test 1" do
    allow Regex.regex?(:foo), return: :foo
    Process.sleep(1_000)
    assert :foo == Regex.regex?(:foo)
    Process.sleep(1_000)
  end
end

defmodule Placebo.Async.Test2 do
  use ExUnit.Case, async: true
  use Placebo
  require Logger

  test "async test 2" do
    allow Regex.regex?(:foo), return: :bar
    Process.sleep(1_000)
    assert :bar == Regex.regex?(:foo)
    Process.sleep(1_000)
  end
end

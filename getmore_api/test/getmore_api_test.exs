defmodule GetmoreApiTest do
  use ExUnit.Case
  doctest GetmoreApi

  test "greets the world" do
    assert GetmoreApi.hello() == :world
  end
end

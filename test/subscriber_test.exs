defmodule SubscriberTest do
  use ExUnit.Case
  doctest Subscriber.Subscriber

  test "greets the world" do
    assert Subscriber.Subscriber.new(:world) == :world
  end
end

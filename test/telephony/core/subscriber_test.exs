defmodule Telephony.Core.SubscriberTest do
  use ExUnit.Case
  # doctest Subscriber.Subscriber
  alias Telephony.Core.{Subscriber, Prepaid, Postpaid}

  test "create a prepaid subscriber" do
    # Given
    payload = %{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: :prepaid
    }

    # When
    result = Subscriber.new(payload)

    # Then
    expect = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Prepaid{credits: 0, recharges: []}
    }

    assert expect == result
  end

  test "create a postpaid subscriber" do
    # Given
    payload = %{
      full_name: "Alex",
      phone_number: "2345",
      subscriber_type: :postpaid
    }

    # When
    result = Subscriber.new(payload)

    # Then
    expect = %Subscriber{
      full_name: "Alex",
      phone_number: "2345",
      subscriber_type: %Postpaid{spent: 0}
    }

    assert expect == result
  end
end

# assert Subscriber.Subscriber.new(:world) == :world

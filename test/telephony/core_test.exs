defmodule Telephony.CoreTest do
  use ExUnit.Case
  alias Telephony.Core
  alias Telephony.Core.Subscriber

  setup do
    subscribers = [
      %Subscriber{
        full_name: "Alex",
        phone_number: "123",
        subscriber_type: :prepaid
      }
    ]

    payload = %{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: :prepaid
    }

    %{subscribers: subscribers, payload: payload}
  end

  test "create new subscriber", %{payload: payload} do
    subscribers = []

    result = Core.create_subscriber(subscribers, payload)

    expect = [
      %Subscriber{
        full_name: "Alex",
        phone_number: "123",
        subscriber_type: :prepaid
      }
    ]

    assert expect == result
  end

  test "create a new subscriber ", %{subscribers: subscribers} do
    payload = %{
      full_name: "John",
      phone_number: "1234",
      subscriber_type: :prepaid
    }

    result = Core.create_subscriber(subscribers, payload)

    expect = [
      %Subscriber{
        full_name: "Alex",
        phone_number: "123",
        subscriber_type: :prepaid
      },
      %Subscriber{
        full_name: "John",
        phone_number: "1234",
        subscriber_type: :prepaid
      }
    ]

    assert expect == result
  end

  test "display error, when subscriber already exist", %{payload: payload} do
    payload = Map.put(payload, :subscriber_type, :asasas)
    result = Core.create_subscriber([], payload)
    assert {:error, "Only 'prepaid' or 'postpaid' are accepted"} == result
  end
end

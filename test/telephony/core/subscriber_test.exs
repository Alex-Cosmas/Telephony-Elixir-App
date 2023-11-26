defmodule Telephony.Core.SubscriberTest do
  use ExUnit.Case
  # doctest Subscriber.Subscriber
  alias Telephony.Core.{Call, Postpaid, Prepaid, Recharge, Subscriber}

  setup do
    postpaid = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Postpaid{spent: 0}
    }

    prepaid = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Prepaid{credits: 10, recharges: []}
    }

    %{postpaid: postpaid, prepaid: prepaid}
  end

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
    expected = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Prepaid{credits: 0, recharges: []}
    }

    assert expected == result
  end

  test "make a postpaid call", %{postpaid: postpaid} do
    # Given
    date = NaiveDateTime.utc_now()
    result = Subscriber.make_call(postpaid, 2, date)

    expected = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Postpaid{spent: 2.08},
      calls: [
        %Call{
          time_spent: 2,
          date: date
        }
      ]
    }

    assert expected == result

    # Then
  end

  test "make a prepaid call", %{prepaid: prepaid} do
    # Given
    date = NaiveDateTime.utc_now()
    result = Subscriber.make_call(prepaid, 2, date)

    expected = %Subscriber{
      calls: [
        %Call{
          date: date,
          time_spent: 2
        }
      ],
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Prepaid{
        credits: 7.1,
        recharges: []
      }
    }

    assert expected == result

    # Then
  end

  test "make a recharge", %{prepaid: prepaid} do
    # Given
    date = NaiveDateTime.utc_now()
    result = Subscriber.make_recharge(prepaid, 2, date)

    expected = %Subscriber{
      calls: [],
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Prepaid{
        credits: 12,
        recharges: [
          %Recharge{value: 2, date: date}
        ]
      }
    }

    assert expected == result
  end

  test "throw error when is not a prepaid", %{postpaid: postpaid} do
    # Given
    date = NaiveDateTime.utc_now()
    result = Subscriber.make_recharge(postpaid, 2, date)
    expected = {:error, "Only prepaid can make a recharge"}
    assert expected == result
  end
end

# assert Subscriber.Subscriber.new(:world) == :world

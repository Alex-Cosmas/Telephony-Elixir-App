defmodule Telephony.Core.SubscriberTest do
  use ExUnit.Case
  # doctest Subscriber.Subscriber
  alias Telephony.Core.{Postpaid, Prepaid, Subscriber, Call, Recharge}

  test "create a subscriber" do
    # Given
    payload = %{
      full_name: "Alex",
      phone_number: "123",
      type: :prepaid
    }

    # When
    result = Subscriber.new(payload)
    # Then
    expected = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      type: %Prepaid{credits: 0, recharges: []}
    }

    assert expected == result
  end

  test "create a postpaid subscriber" do
    # Given
    payload = %{
      full_name: "Alex",
      phone_number: "123",
      type: :postpaid
    }

    # When
    result = Subscriber.new(payload)
    # Then
    expected = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      type: %Postpaid{spent: 0}
    }

    assert expected == result
  end

  test "make a prepaid without credits" do
    subscriber = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      type: %Prepaid{credits: 0, recharges: []}
    }

    date = Date.utc_today()

    assert Subscriber.make_call(subscriber, 1, date) == {:error, "Subsriber does not have credit"}
  end

  test "make a prepaid call" do
    subscriber = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      type: %Prepaid{credits: 10, recharges: []},
      calls: []
    }

    date = Date.utc_today()

    assert Subscriber.make_call(subscriber, 1, date) ==
             %Subscriber{
               full_name: "Alex",
               phone_number: "123",
               type: %Prepaid{credits: 8.55, recharges: []},
               calls: [%Call{time_spent: 1, date: date}]
             }
  end

  test "make a postpaid call" do
    subscriber = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      type: %Postpaid{spent: 0},
      calls: []
    }

    date = Date.utc_today()

    assert Subscriber.make_call(subscriber, 1, date) ==
             %Subscriber{
               calls: [
                 %Call{
                   date: date,
                   time_spent: 1
                 }
               ],
               full_name: "Alex",
               phone_number: "123",
               type: %Postpaid{spent: 1.04}
             }
  end

  test "make a recharge" do
    subscriber = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      type: %Prepaid{credits: 10, recharges: []}
    }

    date = Date.utc_today()

    assert Subscriber.make_recharge(subscriber, 100, date) ==
             %Subscriber{
               calls: [],
               full_name: "Alex",
               phone_number: "123",
               type: %Prepaid{
                 credits: 110,
                 recharges: [
                   %Recharge{value: 100, date: date}
                 ]
               }
             }
  end

  test "make a recharge for postpaid" do
    subscriber = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      type: %Postpaid{spent: 1.04}
    }

    date = Date.utc_today()

    assert Subscriber.make_recharge(subscriber, 100, date) ==
             {:error, "Postpaid can't make a recharge"}
  end

  test "print invoice" do
    subscriber = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      type: %Postpaid{spent: 1.04}
    }

    date = Date.utc_today()

    assert Subscriber.print_invoice(subscriber, 100, date) ==
             %{
               invoice: %{calls: [], value_spent: 0},
               subscriber: %Telephony.Core.Subscriber{
                 full_name: "Alex",
                 phone_number: "123",
                 type: %Telephony.Core.Postpaid{spent: 1.04},
                 calls: []
               }
             }
  end
end

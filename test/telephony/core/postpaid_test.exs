defmodule Telephony.Core.PostpaidTest do
  use ExUnit.Case
  # doctest Subscriber.Subscriber
  alias Telephony.Core.{Call, Postpaid, Subscriber}

  setup do
    subscriber = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Postpaid{spent: 0},
      calls: []
    }

    %{subscriber: subscriber}
  end

  test "make a call", %{subscriber: subscriber} do
    time_spent = 2
    date = NaiveDateTime.utc_now()
    result = Postpaid.make_call(subscriber, time_spent, date)

    expect = %Subscriber{
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

    assert expect == result
  end

  test "print invoice" do
    date = ~D[2023-11-01]
    last_month = ~D[2023-10-01]

    subscriber = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Postpaid{spent: 90 * 1.04},
      calls: [
        %Call{
          time_spent: 10,
          date: date
        },
        %Call{
          time_spent: 50,
          date: last_month
        },
        %Call{
          time_spent: 30,
          date: last_month
        }
      ]
    }

    subsciber_type = subscriber.subscriber_type
    calls = subscriber.calls

    expect = %{
      value_spent: 80 * 1.04,
      calls: [
        %{
          time_spent: 50,
          value_spent: 50 * 1.04,
          date: last_month
        },
        %{
          time_spent: 30,
          time_spent: 30 * 1.04,
          date: last_month
        }
      ]
    }

    assert expect == Invoice.print(subsciber_type, calls, 2022, 10)
  end
end

# test "attempt to make a call", %{subscriber_without_credits: subscriber} do
#   time_spent = 2
#   date = NaiveDateTime.utc_now()
#   result = Prepaid.make_call(subscriber, time_spent, date)
#   expect = {:error, "Subsriber does not have credit"}
#   assert expect == result
# end

# test "make a recharge", %{subscriber: subscriber} do
#   value = 100
#   date = NaiveDateTime.utc_now()

#   result = Prepaid.make_recharge(subscriber, value, date)

#   expect = %Subscriber{
#     full_name: "Alex",
#     phone_number: "123",
#     subscriber_type: %Prepaid{
#       credits: 110,
#       recharges: [
#         %Recharge{value: 100, date: date}
#       ]
#     },
#     calls: []
#   }

#   assert expect == result
# end

# Given

# When

# Then

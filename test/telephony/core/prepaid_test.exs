defmodule Telephony.Core.PrepaidTest do
  use ExUnit.Case
  # doctest Subscriber.Subscriber
  alias Telephony.Core.{Call, Prepaid, Recharge, Subscriber}

  setup do
    subscriber = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Prepaid{credits: 10, recharges: []}
    }

    subscriber_without_credits = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Prepaid{credits: 0, recharges: []}
    }

    %{subscriber: subscriber, subscriber_without_credits: subscriber_without_credits}
  end

  test "make a call", %{subscriber: subscriber} do
    time_spent = 2
    date = NaiveDateTime.utc_now()
    result = Prepaid.make_call(subscriber, time_spent, date)

    expect = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Prepaid{credits: 7.1, recharges: []},
      calls: [
        %Call{
          time_spent: 2,
          date: date
        }
      ]
    }

    assert expect == result
  end

  test "attempt to make a call", %{subscriber_without_credits: subscriber} do
    time_spent = 2
    date = NaiveDateTime.utc_now()
    result = Prepaid.make_call(subscriber, time_spent, date)
    expect = {:error, "Subsriber does not have credit"}
    assert expect == result
  end

  test "make a recharge", %{subscriber: subscriber} do
    value = 100
    date = NaiveDateTime.utc_now()

    result = Prepaid.make_recharge(subscriber, value, date)

    expect = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Prepaid{
        credits: 110,
        recharges: [
          %Recharge{value: 100, date: date}
        ]
      },
      calls: []
    }

    assert expect == result
  end

  test "print invoice" do
    date = ~D[2023-11-01]
    last_month = ~D[2023-10-01]

    subscriber = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      subscriber_type: %Prepaid{
        credits: 253.6,
        recharges: [
          %Recharge{value: 100, date: date},
          %Recharge{value: 100, date: last_month},
          %Recharge{value: 100, date: last_month}
        ]
      },
      calls: [
        %Call{
          time_spent: 2,
          date: date
        },
        %Call{
          time_spent: 10,
          date: last_month
        },
        %Call{
          time_spent: 20,
          date: last_month
        }
      ]
    }

    subscriber_type = subscriber.subscriber_type
    calls = subscriber.calls

    assert Invoice.print(subscriber_type, calls, 2023, 10) == %{
             calls: [
               %{
                 time_spent: 10,
                 value_spent: 14.5,
                 date: last_month
               },
               %{
                 time_spent: 20,
                 value_spent: 29.0,
                 date: last_month
               }
             ],
             recharges: [
               %Recharge{value: 100, date: last_month},
               %Recharge{value: 100, date: last_month}
             ]
           }
  end
end

# Given

# When

# Then
# test "print invoice" do
#   date = ~D[2023-11-26]
#   last_month = ~D[2023-11-26]

#   subscriber = %Subscriber{
#     full_name: "Alex",
#     phone_number: "123",
#     subscriber_type: %Prepaid{
#       credits: 110,
#       recharges: [
#         %Recharge{value: 100, date: date}
#         %Recharge{value: 100, date: last_month}
#         %Recharge{value: 100, date: last_month}
#       ]
#     },
#     calls: [
#       %Call{
#         time_spent: 2,
#         date: date
#       },
#       %Call{
#         time_spent: 2,
#         date: date
#       },
#       %Call{
#         time_spent: 2,
#         date: date
#       }
#     ]
#   }

#   assert expect == "sasfsdfds"
# end
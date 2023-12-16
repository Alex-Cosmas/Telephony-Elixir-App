defmodule Telephony.Core.PostpaidTest do
  use ExUnit.Case
  # doctest Subscriber.Subscriber
  alias Telephony.Core.{Call, Postpaid}

  setup do
    %{postpaid: %Postpaid{spent: 0}}
  end

  test "make a call", %{postpaid: postpaid} do
    time_spent = 2
    date = NaiveDateTime.utc_now()
    result = Subscriber.make_call(postpaid, time_spent, date)
    expect = {%Postpaid{spent: 2.08}, %Telephony.Core.Call{time_spent: 2, date: date}}
    assert expect == result
  end

  test "try to make a recharge" do
    postpaid = %Postpaid{spent: 90 * 1.04}
    assert {:error, "sdsdf"} = Subscriber.make_recharge(postpaid, 100, Date.utc_today())
  end

  test "print invoice" do
    date = ~D[2022-11-01]
    last_month = ~D[2022-10-01]

    postpaid = %Postpaid{spent: 90 * 1.04}

    calls = [
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

    assert expect == Subscriber.print_invoice(postpaid, calls, 2022, 10)
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

# expect = %Telephony.Core.Subscriber{
#   full_name: "Alex",
#   phone_number: "123",
#   subscriber_type: %Postpaid{spent: 2.08},
#   calls: [
#     %Call{
#       time_spent: 2,
#       date: date
#     }
#   ]
# }

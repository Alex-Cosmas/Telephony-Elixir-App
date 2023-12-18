defmodule Telephony.Core.SubscriberTest do
  use ExUnit.Case
  # doctest Subscriber.Subscriber
  alias Telephony.Core.{Postpaid, Prepaid, Subscriber, Call}

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
      type: %Prepaid{credits: 10, recharges: []}
    }

    date = Date.utc_today()

    assert Subscriber.make_call(subscriber, 1, date) ==
             %Subscriber{
               full_name: "Alex",
               phone_number: "123",
               type: %Prepaid{credits: 8.55, recharges: []},
               calls: %Call{time_spent: 1, date: date}
             }
  end

  test "make a postpaid call" do
    subscriber = %Subscriber{
      full_name: "Alex",
      phone_number: "123",
      type: %Postpaid{spent: 0}
    }

    date = Date.utc_today()

    assert Subscriber.make_call(subscriber, 1, date) ==
             %Subscriber{
               calls: %Call{
                 date: date,
                 time_spent: 1
               },
               full_name: "Alex",
               phone_number: "123",
               type: %Postpaid{spent: 1.04}
             }
  end

  # setup do
  #   postpaid = %Subscriber{
  #     full_name: "Alex",
  #     phone_number: "123",
  #     type: %Postpaid{spent: 0}
  #   }

  #   prepaid = %Subscriber{
  #     full_name: "Alex",
  #     phone_number: "123",
  #     type: %Prepaid{credits: 10, recharges: []}
  #   }

  #   %{postpaid: postpaid, prepaid: prepaid}
  # end

  # test "create a prepaid subscriber" do
  #   # Given
  #   payload = %{
  #     full_name: "Alex",
  #     phone_number: "123",
  #     type: :prepaid
  #   }

  #   # When
  #   result = Subscriber.new(payload)

  #   # Then
  #   expected = %Subscriber{
  #     full_name: "Alex",
  #     phone_number: "123",
  #     type: %Prepaid{credits: 0, recharges: []}
  #   }

  #   assert expected == result
  # end

  # test "make a postpaid call", %{postpaid: postpaid} do
  #   # Given
  #   date = NaiveDateTime.utc_now()
  #   result = Subscriber.make_call(postpaid, 2, date)

  #   expected = %Subscriber{
  #     full_name: "Alex",
  #     phone_number: "123",
  #     type: %Postpaid{spent: 2.08},
  #     calls: [
  #       %Call{
  #         time_spent: 2,
  #         date: date
  #       }
  #     ]
  #   }

  #   assert expected == result

  #   # Then
  # end

  # test "make a prepaid call", %{prepaid: prepaid} do
  #   # Given
  #   date = NaiveDateTime.utc_now()
  #   result = Subscriber.make_call(prepaid, 2, date)

  #   expected = %Subscriber{
  #     calls: [
  #       %Call{
  #         date: date,
  #         time_spent: 2
  #       }
  #     ],
  #     full_name: "Alex",
  #     phone_number: "123",
  #     type: %Prepaid{
  #       credits: 7.1,
  #       recharges: []
  #     }
  #   }

  #   assert expected == result

  #   # Then
  # end

  # test "make a recharge", %{prepaid: prepaid} do
  #   # Given
  #   date = NaiveDateTime.utc_now()
  #   result = Subscriber.make_recharge(prepaid, 2, date)

  #   expected = %Subscriber{
  #     calls: [],
  #     full_name: "Alex",
  #     phone_number: "123",
  #     type: %Prepaid{
  #       credits: 12,
  #       recharges: [
  #         %Recharge{value: 2, date: date}
  #       ]
  #     }
  #   }

  #   assert expected == result
  # end

  # test "throw error when is not a prepaid", %{postpaid: postpaid} do
  #   # Given
  #   date = NaiveDateTime.utc_now()
  #   result = Subscriber.make_recharge(postpaid, 2, date)
  #   expected = {:error, "Only prepaid can make a recharge"}
  #   assert expected == result
  # end
end

# assert Subscriber.Subscriber.new(:world) == :world

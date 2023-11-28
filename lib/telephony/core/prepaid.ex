defmodule Telephony.Core.Prepaid do
  alias Telephony.Core.Call
  alias Telephony.Core.Recharge
  defstruct credits: 0, recharges: []
  @price_per_minute 1.45

  def make_call(%{subscriber_type: subscriber_type} = subscriber, time_spent, date) do
    if is_subscriber_has_credits(subscriber_type, time_spent) do
      subscriber
      |> update_credit_spent(time_spent)
      |> add_new_call(time_spent, date)
    else
      {:error, "Subsriber does not have credit"}
    end
  end

  def make_recharge(%{subscriber_type: subscriber_type} = subscriber, value, date) do
    recharge = Recharge.new(value, date)

    subscriber_type = %{
      subscriber_type
      | recharges: subscriber_type.recharges ++ [recharge],
        credits: subscriber_type.credits + value
    }

    %{subscriber | subscriber_type: subscriber_type}
  end

  defp is_subscriber_has_credits(subscriber_type, time_spent) do
    subscriber_type.credits >= @price_per_minute * time_spent
  end

  defp update_credit_spent(%{subscriber_type: subscriber_type} = subscriber, time_spent) do
    credit_spent = @price_per_minute * time_spent
    subscriber_type = %{subscriber_type | credits: subscriber_type.credits - credit_spent}
    %{subscriber | subscriber_type: subscriber_type}
  end

  defp add_new_call(subscriber, time_spent, date) do
    call = Call.new(time_spent, date)
    %{subscriber | calls: subscriber.calls ++ [call]}
  end

  defimpl Invoice, for: Telephony.Core.Prepaid do
    @price_per_minute 1.45

    def print(%{recharges: recharges} = subscriber_type, calls, year, month) do
      recharges = Enum.filter(recharges, &(&1.date.year == year and &1.date.month == month))

      calls =
        Enum.reduce(calls, [], fn call, acc ->
          if call.date.year == year and call.date.month == month do
            value_spent = call.time_spent * @price_per_minute
            call = %{date: call.date, time_spent: call.time_spent, value_spent: value_spent}

            acc ++ [call]
          else
            acc
          end
        end)

      %{
        recharges: recharges,
        calls: calls
      }
    end
  end
end

# subscriber =
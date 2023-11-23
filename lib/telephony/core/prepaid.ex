defmodule Telephony.Core.Prepaid do
  alias Telephony.Core.Call
  defstruct credits: 0, recharges: []
  @price_per_minute 1.45

  def make_call(subscriber, time_spent, date) do
    subscriber
    |> update_credit_spent(time_spent)
    |> add_new_call(time_spent, date)
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
end

# subscriber =

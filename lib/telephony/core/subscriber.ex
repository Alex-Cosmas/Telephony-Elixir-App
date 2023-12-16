defprotocol Subscriber do
  @fallback_to_any true
  def print_invoice(subscriber_type, calls, year, month)
  def make_call(subscriber_type, time_spent, date)
  def make_recharge(subscriber_type, value, date)
  # def subscriber_type(subscriber_type)
end

defmodule Telephony.Core.Subscriber do
  alias Telephony.Core.{Postpaid, Prepaid}

  defstruct full_name: nil, phone_number: nil, subscriber_type: :prepaid, calls: []

  def new(%{subscriber_type: :prepaid} = payload) do
    payload = %{payload | subscriber_type: %Prepaid{}}
    struct(__MODULE__, payload)
  end

  def new(%{subscriber_type: :postpaid} = payload) do
    payload = %{payload | subscriber_type: %Postpaid{}}
    struct(__MODULE__, payload)
  end
end

# def make_call(%{subscriber_type: subscriber_type} = subscriber, time_spent, date)
#     when subscriber_type.__struct__ == Postpaid do
#   Postpaid.make_call(subscriber, time_spent, date)
# end

# def make_call(%{subscriber_type: subscriber_type} = subscriber, time_spent, date)
#     when subscriber_type.__struct__ == Prepaid do
#   Prepaid.make_call(subscriber, time_spent, date)
# end

# def make_recharge(%{subscriber_type: subscriber_type} = subscriber, value, date)
#     when subscriber_type.__struct__ == Prepaid do
#   Prepaid.make_recharge(subscriber, value, date)
# end

# def make_recharge(_, _, _) do
#   {:error, "Only prepaid can make a recharge"}
# end

# payload

# %__MODULE__{
#   full_name: payload.full_name,
#   id: payload.id,
#   phone_number: payload.phone_number,
#   subscriber_type: :prepaid
# }

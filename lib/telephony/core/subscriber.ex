defprotocol Subscriber do
  @fallback_to_any true
  def print_invoice(type, calls, year, month)
  def make_call(type, time_spent, date)
  def make_recharge(type, value, date)
  # def type(type)
end

defmodule Telephony.Core.Subscriber do
  alias Telephony.Core.{Postpaid, Prepaid}

  defstruct full_name: nil, phone_number: nil, type: :prepaid, calls: []

  def new(%{type: :prepaid} = payload) do
    payload = %{payload | type: %Prepaid{}}
    struct(__MODULE__, payload)
  end

  def new(%{type: :postpaid} = payload) do
    payload = %{payload | type: %Postpaid{}}
    struct(__MODULE__, payload)
  end

  def make_call(subscriber, time_spent, date) do
    case Subscriber.make_call(subscriber.type, time_spent, date) do
      {:error, message} ->
        {:error, message}

      {type, call} ->
        %{subscriber | type: type, calls: subscriber.calls ++ [call]}
    end
  end

  def make_recharge(subscriber, value, date) do
    # type
    # %{subscriber | type: type}

    case Subscriber.make_recharge(subscriber.type, value, date) do
      {:error, message} ->
        {:error, message}

      type ->
        # %{subscriber | type: type, calls: subscriber.calls ++ call}
        %{subscriber | type: type}
    end
  end

  def print_invoice(subscriber, year, month) do
    invoice = Subscriber.print_invoice(subscriber.type, subscriber.calls, year, month)

    %{
      subscriber: subscriber,
      invoice: invoice
    }
  end
end

# def make_call(%{type: type} = subscriber, time_spent, date)
#     when type.__struct__ == Postpaid do
#   Postpaid.make_call(subscriber, time_spent, date)
# end

# def make_call(%{type: type} = subscriber, time_spent, date)
#     when type.__struct__ == Prepaid do
#   Prepaid.make_call(subscriber, time_spent, date)
# end

# def make_recharge(%{type: type} = subscriber, value, date)
#     when type.__struct__ == Prepaid do
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
#   type: :prepaid
# }

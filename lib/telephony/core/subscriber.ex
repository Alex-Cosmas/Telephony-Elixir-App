defmodule Telephony.Core.Subscriber do
  alias Telephony.Core.{Prepaid, Postpaid}

  defstruct full_name: nil, phone_number: nil, subscriber_type: :prepaid

  def new(%{subscriber_type: :prepaid} = payload) do
    payload = %{payload | subscriber_type: %Prepaid{}}
    struct(__MODULE__, payload)
  end

  def new(%{subscriber_type: :postpaid} = payload) do
    payload = %{payload | subscriber_type: %Postpaid{}}
    struct(__MODULE__, payload)
  end
end

# payload

# %__MODULE__{
#   full_name: payload.full_name,
#   id: payload.id,
#   phone_number: payload.phone_number,
#   subscriber_type: :prepaid
# }

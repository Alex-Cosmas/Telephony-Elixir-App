defmodule Telephony.Core.Subscriber do
  defstruct full_name: nil, phone_number: nil, subscriber_type: :prepaid

  def new(payload) do
    # payload

    # %__MODULE__{
    #   full_name: payload.full_name,
    #   id: payload.id,
    #   phone_number: payload.phone_number,
    #   subscriber_type: :prepaid
    # }

    struct(__MODULE__, payload)
  end
end

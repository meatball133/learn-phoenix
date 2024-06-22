defmodule PhoneApp.Conversations.Schema.Contact do
  use Ecto.Schema

  @timestamps_opts [type: :utc_datetime_usec]
  schema "contacts" do
    has_many :sms_messages, PhoneApp.Conversations.Schema.SmsMessage

    field :name, :string
    field :phone_number, :string

    timestamps()
  end

  import Ecto.Changeset

  def changeset(attrs) do
    fields = [:phone_number]

    %__MODULE__{}
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> unique_constraint(:phone_number)
  end
end

defmodule PhoneApp.Conversations.Query.SmsMessageStore do
  import Ecto.Query

  alias PhoneApp.Repo
  alias PhoneApp.Conversations.Schema.SmsMessage
  alias PhoneApp.Conversations.Query.ContactStore

  def create_sms_message(params) do
    {:ok, contact} = ContactStore.upsert_contact(params)

    params
    |> Map.merge(%{contact_id: contact.id})
    |> SmsMessage.changeset()
    |> Repo.insert()
  end

  @spec update_sms_message(any(), any()) :: any()
  def update_sms_message(message_sid, update_params) do
    case Repo.get_by(SmsMessage, message_sid: message_sid) do
      nil -> {:error, "Message not found"}
      sms_message ->
        update_params
        |> SmsMessage.update_changeset(sms_message)
        |> Repo.update()
    end
  end

  def load_message_with(contact) do
    from(s in SmsMessage, where: s.contact_id == ^contact.id, order_by: [desc: s.inserted_at], preload: [:contact])
    |> Repo.all()
  end

  def load_message_list do
    distinct_query = from(s in SmsMessage, select: s.id, distinct: [s.contact_id], order_by: [desc: s.inserted_at])

    from(s in SmsMessage, where: s.id in subquery(distinct_query), order_by: [desc: s.inserted_at], preload: [:contact])
    |> Repo.all()
  end

  def get_message!(id) do
    Repo.get!(SmsMessage, id)
  end
end

defmodule PhoneApp.Conversations do
  alias PhoneApp.Conversations.Schema
  alias PhoneApp.Conversations.Query

  defdelegate get_contact!(id), to: Query.ContactStore

  defdelegate create_sms_message(params), to: Query.SmsMessageStore

  defdelegate update_sms_message(message_sid, params), to: Query.SmsMessageStore

  def load_conversation_list do
    messages = Query.SmsMessageStore.load_message_list()

    Enum.map(messages, fn message ->
      %Schema.Conversation{contact: message.contact, messages: [message]}
    end)
  end

  def load_conversation_with(contact) do
    messages = Query.SmsMessageStore.load_message_with(contact)

    %Schema.Conversation{contact: contact, messages: messages}
  end

  defdelegate new_message_changeset(params), to: Schema.SmsMessage, as: :changeset

  def send_sms_message(params = %Schema.NewMessage{}) do
    params = %{
      message_sid: Ecto.UUID.generate(),
      account_sid: "mock",
      body: params.body,
      from: "mock",
      to: params.to,
      status: "mock",
      direction: :outgoing
    }

    create_sms_message(params)
  end
end

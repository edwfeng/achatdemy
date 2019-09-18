defmodule Achatdemy.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :msg, :string
    field :chat_id, :id
    field :author_id, :id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:msg])
    |> validate_required([:msg])
  end
end

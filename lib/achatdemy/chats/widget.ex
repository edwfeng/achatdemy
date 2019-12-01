defmodule Achatdemy.Chats.Widget do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "widgets" do
    field :desc, :string
    field :uri, :string
    belongs_to :chat, Achatdemy.Chats.Chat

    timestamps()
  end

  @doc false
  def changeset(widget, attrs) do
    widget
    |> cast(attrs, [:desc, :uri, :chat_id])
    |> validate_required([:desc, :uri, :chat_id])
  end
end

defmodule Achatdemy.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :msg, :string
    belongs_to :chat, Achatdemy.Chats.Chat
    belongs_to :user, Achatdemy.Users.User

    many_to_many(:files, Achatdemy.Messages.File, join_through: "msg_files_xref")

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:msg])
    |> validate_required([:msg])
  end
end

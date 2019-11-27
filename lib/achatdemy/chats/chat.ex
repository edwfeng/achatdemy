defmodule Achatdemy.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chats" do
    field :title, :string
    field :type, :integer

    belongs_to :user, Achatdemy.Users.User
    belongs_to :comm, Achatdemy.Comms.Comm

    has_many :messages, Achatdemy.Messages.Message
    has_many :widgets, Achatdemy.Chats.Widget

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:title, :type, :comm_id, :user_id])
    |> validate_required([:title, :type, :comm_id])
  end
end

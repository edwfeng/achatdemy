defmodule Achatdemy.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string

    has_many :chats, Achatdemy.Chats.Chat
    has_many :messages, Achatdemy.Messages.Message

    many_to_many(:comms, Achatdemy.Comms.Comm, join_through: "user_perms")

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :email])
    |> validate_required([:username, :password, :email])
  end
end

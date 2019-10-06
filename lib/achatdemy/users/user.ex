defmodule Achatdemy.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string

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

defmodule Achatdemy.Comms.Comm do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "comms" do
    field :name, :string

    many_to_many(:users, Achatdemy.Users.User, join_through: "user_perms")

    timestamps()
  end

  @doc false
  def changeset(comm, attrs) do
    comm
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

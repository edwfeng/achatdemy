defmodule Achatdemy.Users.Perm do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "user_perms" do
    field :chmod, :binary
    field :user_id, :binary_id
    field :comm_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(perm, attrs) do
    perm
    |> cast(attrs, [:chmod])
    |> validate_required([:chmod])
  end
end

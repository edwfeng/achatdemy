defmodule Achatdemy.Users.Perm do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id
  schema "user_perms" do
    field :chmod, :integer
    belongs_to :user, Achatdemy.Users.User, primary_key: true
    belongs_to :comm, Achatdemy.Comms.Comm, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(perm, attrs) do
    perm
    |> cast(attrs, [:chmod, :user_id, :comm_id])
    |> validate_required([:chmod, :user_id, :comm_id])
  end
end

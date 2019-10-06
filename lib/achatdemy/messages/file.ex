defmodule Achatdemy.Messages.File do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "files" do
    field :name, :string
    field :path, :string

    many_to_many(:messages, Achatdemy.Messages.Message, join_through: "msg_files_xref")

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:name, :path])
    |> validate_required([:name, :path])
  end
end

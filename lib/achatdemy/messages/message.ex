defmodule Achatdemy.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "messages" do
    field :msg, :string
    field :chat_id, :binary_id
    field :author_id, :binary_id

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

defmodule Achatdemy.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "chats" do
    field :title, :string
    field :type, :integer
    field :author_id, :binary_id
    field :comm_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:title, :type])
    |> validate_required([:title, :type])
  end
end

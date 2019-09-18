defmodule Achatdemy.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do
    field :title, :string
    field :type, :string
    field :author_id, :id
    field :comm_id, :id

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:title, :type])
    |> validate_required([:title, :type])
  end
end

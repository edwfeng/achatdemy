defmodule Achatdemy.Chats.Widget do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "widgets" do
    field :desc, :string
    field :uri, :string
    field :chat_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(widget, attrs) do
    widget
    |> cast(attrs, [:desc, :uri])
    |> validate_required([:desc, :uri])
  end
end

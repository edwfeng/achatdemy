defmodule Achatdemy.Repo.Migrations.CreateWidgets do
  use Ecto.Migration

  def change do
    create table(:widgets) do
      add :uri, :string
      add :desc, :string
      add :chat_id, references(:chats, on_delete: :nothing)

      timestamps()
    end

    create index(:widgets, [:chat_id])
  end
end

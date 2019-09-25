defmodule Achatdemy.Repo.Migrations.CreateWidgets do
  use Ecto.Migration

  def change do
    create table(:widgets) do
      add :desc, :text
      add :uri, :string
      add :chat_id, references(:chats, on_delete: :nothing)

      timestamps()
    end

    create index(:widgets, [:chat_id])
  end
end

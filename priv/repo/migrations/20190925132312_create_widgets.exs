defmodule Achatdemy.Repo.Migrations.CreateWidgets do
  use Ecto.Migration

  def change do
    create table(:widgets, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :desc, :text
      add :uri, :string
      add :chat_id, references(:chats, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:widgets, [:chat_id])
  end
end

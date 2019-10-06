defmodule Achatdemy.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :text
      add :type, :integer
      add :user_id, references(:users, on_delete: :nothing, type: :uuid)
      add :comm_id, references(:comms, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:chats, [:user_id])
    create index(:chats, [:comm_id])
  end
end

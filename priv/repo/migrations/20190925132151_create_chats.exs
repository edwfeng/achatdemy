defmodule Achatdemy.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :title, :text
      add :type, :integer
      add :author_id, references(:users, on_delete: :nothing)
      add :comm_id, references(:comms, on_delete: :nothing)

      timestamps()
    end

    create index(:chats, [:author_id])
    create index(:chats, [:comm_id])
  end
end

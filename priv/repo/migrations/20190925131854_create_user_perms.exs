defmodule Achatdemy.Repo.Migrations.CreateUserPerms do
  use Ecto.Migration

  def change do
    create table(:user_perms, primary_key: false) do
      add :chmod, :integer
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid), primary_key: true
      add :comm_id, references(:comms, on_delete: :delete_all, type: :uuid), primary_key: true

      timestamps()
    end

    create index(:user_perms, [:user_id])
    create index(:user_perms, [:comm_id])
  end
end

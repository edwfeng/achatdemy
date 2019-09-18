defmodule Achatdemy.Repo.Migrations.CreateUserPerms do
  use Ecto.Migration

  def change do
    create table(:user_perms) do
      add :chmod, :binary
      add :user_id, references(:users, on_delete: :nothing)
      add :comm_id, references(:comms, on_delete: :nothing)

      timestamps()
    end

    create index(:user_perms, [:user_id])
    create index(:user_perms, [:comm_id])
  end
end

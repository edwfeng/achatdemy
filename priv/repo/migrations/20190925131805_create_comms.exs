defmodule Achatdemy.Repo.Migrations.CreateComms do
  use Ecto.Migration

  def change do
    create table(:comms) do
      add :name, :string

      timestamps()
    end

  end
end

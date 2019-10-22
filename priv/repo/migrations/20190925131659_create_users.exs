defmodule Achatdemy.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :username, :string
      add :password_hash, :string
      add :email, :string

      timestamps()
    end

  end
end

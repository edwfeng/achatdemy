defmodule Achatdemy.Repo.Migrations.AddTrigramIndices do
  use Ecto.Migration

  def up do
    execute("CREATE INDEX users_trgm_index ON users USING gin(username gin_trgm_ops);")
    execute("CREATE INDEX comms_tgrm_index ON comms USING gin(name gin_trgm_ops);")
  end

  def down do
    execute("DROP INDEX users_trgm_index;")
    execute("DROP INDEX comms_tgrm_index;")
  end
end

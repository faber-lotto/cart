defmodule Cart.Repo.Migrations.CreateUuidOssp do
  use Ecto.Migration

  def up do
    execute ~s(CREATE EXTENSION IF NOT EXISTS "uuid-ossp";)
  end

  def down do
    execute ~s(DROP EXTENSION "uuid-ossp";)
  end
end

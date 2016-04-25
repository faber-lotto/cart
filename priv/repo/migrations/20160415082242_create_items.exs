defmodule Cart.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :infos, :map
      add :cart_id, references(:carts, type: :uuid, on_delete: :delete_all)

      timestamps
    end
  end
end

defmodule Cart.Item do

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, read_after_writes: true} 
  @timestamps_opts usec: true

  schema "items" do
    field :infos, :map
    belongs_to :cart, Cart.Cart, type: Ecto.UUID

    timestamps
  end

  @required_fields ["infos", "cart_id"]

  @optional_fields []

  @doc "Create a new item"
  def changeset(params) do
    changeset(%Cart.Item{}, params)
  end

  @doc "Update existing item"
  def changeset(item, params) do
    item
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:cart_id)
  end
end

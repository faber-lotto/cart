defmodule Cart.Item do

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, read_after_writes: true} 
  @timestamps_opts usec: true

  schema "items" do
    field :infos, :map
    belongs_to :cart, Cart.Cart, type: Ecto.UUID

    timestamps(type: :utc_datetime)
  end

  @required_fields [
    :infos,
    :cart_id,
  ]

  @allowed_fields [
    :infos,
    :cart_id,
  ]

  @doc "Create a new item"
  def changeset(params) do
    changeset(%Cart.Item{}, params)
  end

  @doc "Update existing item"
  def changeset(item, params) do
    item
    |> cast(params, @allowed_fields)
    |> foreign_key_constraint(:cart_id)
    |> validate_required(@required_fields)
  end
end

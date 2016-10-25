defmodule Cart.Cart do

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, read_after_writes: true} 

  schema "carts" do
    has_many :items, Cart.Item

    timestamps(type: :utc_datetime)
  end

  @required_fields []

  @optional_fields []

  @doc "Changeset for a new cart"
  def changeset(params) do
    %Cart.Cart{}
    |> cast(params, @required_fields, @optional_fields)
  end
end

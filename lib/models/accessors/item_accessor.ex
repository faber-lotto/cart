defmodule Cart.ItemAccessor do
  @moduledoc """
    Contains item specific queries.
  """

  use Cart.Accessor, Cart.Item
  alias Cart.Repo
  @timestamps_opts usec: true

  def delete_all_from_cart(cart_id, item_ids) do
    from( item in Cart.Item,
      where: item.id in ^item_ids and item.cart_id == ^cart_id)
    |> Repo.delete_all
  end
end

defmodule Cart.ItemAccessor do
  @moduledoc """
    Contains cart specific queries.
  """

  use Cart.Accessor, Cart.Item
  alias Cart.Repo

  def delete_all_from_cart(cart_id, item_ids) do
    from( item in Cart.Item,
      where: item.id in ^item_ids and item.cart_id == ^cart_id)
    |> Repo.delete_all
  end

end

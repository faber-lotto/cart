defmodule Cart.ItemAccessor do
  @moduledoc """
    Contains item specific queries.
  """

  use ExUtils.Ecto.Accessor, [repo: Cart.Repo, model: Cart.Item]
  alias Cart.Repo
  @timestamps_opts usec: true

  def delete_all_from_cart(cart_id, item_ids) do
    from( item in Cart.Item,
      where: item.id in ^item_ids and item.cart_id == ^cart_id)
    |> Repo.delete_all
  end

  def by_id(id) do
    query = from entry in Cart.Item,
      where: entry.id == ^id
    Repo.one(query)
  end
end

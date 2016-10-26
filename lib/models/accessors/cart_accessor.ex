defmodule Cart.CartAccessor do
  @moduledoc """
    Contains cart specific queries.
  """

  use ExUtils.Ecto.Accessor, [repo: Cart.Repo, model: Cart.Cart]
  alias Cart.Repo

  def by_id(id) do
    items_query = from item in Cart.Item, order_by: item.inserted_at
    query = from entry in Cart.Cart,
              where: entry.id == ^id,
              preload: [items: ^items_query]
    Repo.one(query)
  end
end

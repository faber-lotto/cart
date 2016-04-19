defmodule Cart.CartAccessor do
  @moduledoc """
    Contains cart specific queries.
  """

  use Cart.Accessor, Cart.Cart
  alias Cart.Repo

  def by_id(id) do
    query = from entry in Cart.Cart,
              where: entry.id == ^id,
              preload: [:items]
    Repo.one(query)
  end
end

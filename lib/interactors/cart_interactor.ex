defmodule Cart.CartInteractor do
  alias Cart.ItemAccessor
  alias Cart.CartAccessor

  def add_item(cart_id, item) do
    case ItemAccessor.create %{cart_id: cart_id, infos: item} do
      {:ok, _item} -> {:ok, CartAccessor.by_id cart_id}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end

  def add_item(item) do
    Cart.Repo.transaction(fn ->
      cart = CartAccessor.create! %{}
      item_params = %{cart_id: cart.id, infos: item}
      cs = Cart.Item.changeset item_params
      if cs.valid? do
        item = ItemAccessor.create! item_params
        %{cart| items: [item]}
      else
        Cart.Repo.rollback(cs.errors)
      end
    end)
  end

  def show(cart_id) do
    {:ok, CartAccessor.by_id cart_id}
  end 

  def remove_items(cart_id, item_ids) do
    ItemAccessor.delete_all_from_cart(cart_id, item_ids) 
    case {:ok, cart} = show(cart_id) do
      {:ok, %Cart.Cart{items: []}} ->
        CartAccessor.delete cart
        {:ok, nil}
      {:ok, %Cart.Cart{items: _items}} ->
        {:ok, cart}
    end 
  end 

  def remove_cart(cart_id) do
    case CartAccessor.delete %Cart.Cart{id: cart_id} do
      {:ok, _} -> {:ok, nil}
      {:error, cs} -> {:error, cs.errors} 
    end 
  end

  def update_item(item_id, infos) do
    if item = ItemAccessor.by_id(item_id) do
      case ItemAccessor.update(item, %{infos: infos, cart_id: item.cart_id}) do
        {:ok, item} -> show(item.cart_id)
        {:error, cs} -> {:error, cs.errors} 
      end
    else
      {:error, ["item not found"]}
    end 
  end
end

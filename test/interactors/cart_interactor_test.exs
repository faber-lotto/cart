defmodule CartInteractorTest do
  use ExUnit.Case, async: false
  alias Cart.CartInteractor
  alias Cart.CartAccessor
  alias Cart.ItemAccessor

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Cart.Repo)
  end

  test "add_item adds valid item to an existing cart" do
    {:ok, cart} = CartAccessor.create %{}
    item_count = ItemAccessor.count
    {:ok, %Cart.Cart{items: [item]}} = CartInteractor.add_item(cart.id, %{"name" => "foo"})
    assert item.infos == %{"name" => "foo"}
    assert ItemAccessor.count == item_count + 1
    assert {:error, _errors} = CartInteractor.add_item("123", %{})
    assert {:error, _errors} = CartInteractor.add_item(cart.id, [])
  end

  test "add_item creates a new cart if no cart id is provided" do
    item_count = ItemAccessor.count
    cart_count = CartAccessor.count
    {:ok, %Cart.Cart{items: [item]}} = CartInteractor.add_item(%{"name" => "bar"})
    assert item.infos == %{"name" => "bar"}
    assert ItemAccessor.count == item_count + 1
    assert CartAccessor.count == cart_count + 1
    assert {:error, _errors} = CartInteractor.add_item([])
  end

  test "show returns an existing cart with all its items" do
    {:ok, cart} = CartInteractor.add_item(%{"name" => "bar"})
    {:ok, %Cart.Cart{items: [%Cart.Item{}]}} = CartInteractor.show(cart.id)
    {:ok, nil} = CartInteractor.show(Ecto.UUID.generate)
  end

  test "remove_items removes a list of items from a given cart" do
    {:ok, cart} = CartInteractor.add_item(%{"name" => "foo"})
    CartInteractor.add_item(cart.id, %{"name" => "bar"})
    {:ok, %Cart.Cart{items: [_h|t]}} = CartInteractor.add_item(cart.id, %{"name" => "baz"})
    assert {:ok, %Cart.Cart{items: [_item]}} =
           CartInteractor.remove_items(cart.id, Enum.map(t, &Map.get(&1, :id)))
  end

  test "remove_items removes carts if all their items are removed" do
    {:ok, %Cart.Cart{id: cart_id, items: [item]}} = CartInteractor.add_item(%{"name" => "foo"})
    cart_count = CartAccessor.count
    CartInteractor.remove_items(cart_id, [item.id])
    assert {:ok, nil} = CartInteractor.show cart_id
    assert cart_count - 1 == CartAccessor.count
  end

  test "remove_cart removes a given cart" do
    {:ok, cart} = CartInteractor.add_item(%{"name" => "foo"})
    cart_count = CartAccessor.count
    assert {:ok, nil} = CartInteractor.remove_cart cart.id
    assert {:ok, nil} = CartInteractor.show cart.id
    assert cart_count - 1 == CartAccessor.count
  end

  test "update_item replaces infos of an existing item" do
    {:ok, %Cart.Cart{items: [item]}} = CartInteractor.add_item(%{"name" => "foo"})
    new_infos = %{"name" => "bar"}
    {:ok, %Cart.Cart{items: [%Cart.Item{infos: _new_infos}]}} =
    CartInteractor.update_item(item.id, new_infos)
    assert {:ok, %Cart.Cart{items: [%Cart.Item{infos: %{"name" => "bar"}}]}} =
           CartInteractor.show(item.cart_id)
  end
end

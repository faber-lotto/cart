defmodule CartServerTest do
  use ExUnit.Case, async: false
  alias Cart.CartInteractor
  alias Cart.CartAccessor
  alias Cart.ItemAccessor

  setup_all do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Cart.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Cart.Repo, {:shared, self()})

    app_name = Mix.Project.config[:app]
    server = {Cart.Server, Application.get_env(app_name, :cart_node)}
    {:ok, [server: server]}
  end

  test "add_item adds valid item to an existing cart", context do
    server = context[:server]
    {:ok, cart} = CartAccessor.create %{}
    item_count = ItemAccessor.count
    item = %{"name" => "foo"}
    {:ok, %Cart.Cart{items: [item]}} = GenServer.call(server, {:add_item, cart.id, item})
    assert item.infos == %{"name" => "foo"}
    assert ItemAccessor.count == item_count + 1
    assert {:error, _errors} = CartInteractor.add_item("123", %{})
    assert {:error, _errors} = CartInteractor.add_item(cart.id, [])
  end

  test "add_item creates a new cart if no cart id is provided", context do
    server = context[:server]
    item_count = ItemAccessor.count
    cart_count = CartAccessor.count
    {:ok, %Cart.Cart{items: [item]}} = GenServer.call(server, {:add_item, %{"name" => "bar"}})
    assert item.infos == %{"name" => "bar"}
    assert ItemAccessor.count == item_count + 1
    assert CartAccessor.count == cart_count + 1
    assert {:error, _errors} = CartInteractor.add_item([])
  end

  test "show returns an existing cart with all its items", context do
    server = context[:server]
    {:ok, cart} = CartInteractor.add_item(%{"name" => "bar"})
    {:ok, %Cart.Cart{items: [%Cart.Item{}]}} = GenServer.call(server, {:show, cart.id})
    {:ok, nil} = CartInteractor.show(Ecto.UUID.generate)
  end

  test "remove_items removes a list of items from a given cart", context do
    server = context[:server]
    {:ok, cart} = CartInteractor.add_item(%{"name" => "foo"})
    CartInteractor.add_item(cart.id, %{"name" => "bar"})
    {:ok, %Cart.Cart{items: [_h|t]}} = CartInteractor.add_item(cart.id, %{"name" => "baz"})
    assert {:ok, %Cart.Cart{items: [_item]}} =
           GenServer.call(server, {:remove_items, cart.id, Enum.map(t, &Map.get(&1, :id))})
  end

  test "remove_items removes carts if all their items are removed", context do
    server = context[:server]
    {:ok, %Cart.Cart{id: cart_id, items: [item]}} = CartInteractor.add_item(%{"name" => "foo"})
    cart_count = CartAccessor.count
    GenServer.call(server, {:remove_items, cart_id, [item.id]})
    assert {:ok, nil} = CartInteractor.show cart_id
    assert cart_count - 1 == CartAccessor.count
  end

  test "remove_cart removes a given cart", context do
    server = context[:server]
    {:ok, cart} = CartInteractor.add_item(%{"name" => "foo"})
    cart_count = CartAccessor.count
    assert {:ok, nil} = GenServer.call(server, {:remove_cart, cart.id})
    assert {:ok, nil} = CartInteractor.show cart.id
    assert cart_count - 1 == CartAccessor.count
  end

  test "update_item replaces infos of an existing item", context do
    server = context[:server]
    {:ok, %Cart.Cart{items: [item]}} = CartInteractor.add_item(%{"name" => "foo"})
    new_infos = %{"name" => "bar"}
    updated_item = %Cart.Item{infos: new_infos}
    {:ok, %Cart.Cart{items: [%Cart.Item{infos: _new_infos}]}} =
    GenServer.call(server, {:update_item, item.id, new_infos})
    assert {:ok, %Cart.Cart{items: [%Cart.Item{infos: _new_infos}]}} =
           CartInteractor.show(item.cart_id)
  end
end

defmodule ItemAccessorTest do
  use ExUnit.Case, async: false

  setup_all do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Cart.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Cart.Repo, {:shared, self()})

    {:ok, cart} = Cart.CartAccessor.create %{}
    {:ok, [cart: cart]}
  end

  test "Item is persisted correctly", context do
    cart_id = context[:cart].id
    infos = %{"name" => "test"}
    item_params = %{cart_id: cart_id, infos: infos}
    assert {:ok, %Cart.Item{}} = Cart.ItemAccessor.create item_params
  end

  test "Items are deleted when the parent cart is deleted" do
    {:ok, cart} = Cart.CartAccessor.create %{}
    item_params = %{cart_id: cart.id, infos: %{"test" => 1}}
    {:ok, item} = Cart.ItemAccessor.create item_params
    Cart.CartAccessor.delete cart
    assert Cart.ItemAccessor.by_id(item.id) |> is_nil
  end

  test "Items can be updated", context do
    item_params = %{cart_id: context[:cart].id, infos: %{"name" => "foo"}}
    {:ok, item} = Cart.ItemAccessor.create item_params
    {:ok, updated_item} = Cart.ItemAccessor.update(item, %{infos: %{"name" => "bar"}}) 
    assert updated_item.infos == %{"name" => "bar"}
  end
end

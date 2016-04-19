defmodule CartAccessorTest do
  use ExUnit.Case, async: false

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Cart.Repo)
  end

  test "Cart is persisted correctly" do
    count = Cart.CartAccessor.count
    assert {:ok, _cart} = Cart.CartAccessor.create %{}
    assert (count + 1) == Cart.CartAccessor.count
  end

  test "Cart is deleted correctly" do
    assert {:ok, cart} = Cart.CartAccessor.create %{}
    count = Cart.CartAccessor.count
    Cart.CartAccessor.delete cart 
    assert (count - 1) == Cart.CartAccessor.count
  end
end

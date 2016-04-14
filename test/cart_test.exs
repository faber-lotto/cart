defmodule CartTest do
  use ExUnit.Case, async: false

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Cart.Repo)
  end

  test "truth" do
    assert 2 == 1 + 1
  end
end

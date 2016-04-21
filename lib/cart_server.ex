defmodule Cart.Server do
  use GenServer
  alias Cart.CartInteractor

  # Client

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: Cart.Server)
  end

  ## Server

  def handle_call({:add_item, cart_id, item}, _from, _state) do
    {:reply, CartInteractor.add_item(cart_id, item), nil}
  end

  def handle_call({:add_item, item}, _from, _state) do
    {:reply, CartInteractor.add_item(item), nil}
  end

  def handle_call({:show, cart_id}, _from, _state) do
    {:reply, CartInteractor.show(cart_id), nil}
  end

  def handle_call({:remove_items, cart_id, items}, _from, _state) do
    {:reply, CartInteractor.remove_items(cart_id, items), nil}
  end

  def handle_call({:remove_cart, cart_id}, _from, _state) do
    {:reply, CartInteractor.remove_cart(cart_id), nil}
  end

  def handle_call({:update_item, item_id, infos}, _from, _state) do
    {:reply, CartInteractor.update_item(item_id, infos), nil}
  end
end

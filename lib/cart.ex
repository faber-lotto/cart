defmodule Cart do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    tree = [supervisor(Cart.Repo, []),
            worker(Cart.Server, [])]
    opts = [name: Cart.Sup, strategy: :one_for_one]
    Supervisor.start_link(tree, opts)
  end
end

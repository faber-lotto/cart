defmodule Cart.Repo do
  use Ecto.Repo, otp_app: :cart
  import Ecto.Query

  @moduledoc """
  An `Ecto.Repo` for accessing the database.
  """

  @doc """
  count the number of records in the model table
  """
  def count(model) do
    {:ok, %{rows: [[n_rows]]}} = Ecto.Adapters.SQL.query(__MODULE__,
        "SELECT COUNT(*) FROM #{model.__schema__(:source)}", [])
    n_rows
  end
end

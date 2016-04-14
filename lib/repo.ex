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
    query = "SELECT COUNT(*) FROM #{model.__schema__(:source)}"
    {:ok, %{rows: [[n_rows]]}} = Ecto.Adapters.SQL.query(__MODULE__, query, [])
    n_rows
  end
end

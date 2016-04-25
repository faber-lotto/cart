defmodule Cart.Accessor do
  alias Cart.Repo

  @moduledoc """
    Contains common queries.
  """

  defmacro __using__([]) do
    raise "You need to provide a model when using #{__MODULE__}!"
  end

  defmacro __using__(resource) do
    quote location: :keep do
      import Ecto.Query

      def by_id(id) do
        query = from entry in unquote(resource),
          where: entry.id == ^id
        Repo.one(query)
      end

      def all do
        Repo.all(from entry in unquote(resource))
      end

      def count do
        Repo.count(unquote(resource))
      end

      def delete(entry) do
        Repo.delete(entry)
      end

      def delete!(entry) do
        Repo.delete!(entry)
      end

      def delete_all do
        Repo.delete_all(unquote(resource))
      end

      def create(params) do
        changeset = unquote(resource).changeset(params)
        case changeset.valid? do
          true  -> Repo.insert(changeset)
          false -> {:error, changeset}
        end
      end

      def create!(params) do
        unquote(resource).changeset(params)
        |> Repo.insert!
      end

      def update(entry, params) do
        unquote(resource).changeset(entry, params)
        |> Repo.update
      end

      def update!(entry, params) do
        unquote(resource).changeset(entry, params)
        |> Repo.update!
      end

      defoverridable [by_id: 1, all: 0, create: 1, delete: 1, update: 2]
    end
  end
end

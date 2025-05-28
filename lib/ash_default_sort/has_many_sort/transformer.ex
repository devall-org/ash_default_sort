defmodule AshDefaultSort.HasManySort.Transformer do
  alias Spark.Dsl.Transformer
  use Transformer

  @impl Spark.Dsl.Transformer
  def transform(dsl_state) do
    case Transformer.get_option(dsl_state, [:default_sort], :has_many_sort) do
      [] ->
        :ok

      has_many_sort ->
        dsl_state =
          dsl_state
          |> Transformer.get_entities([:relationships])
          |> Enum.filter(&(&1.type == :has_many))
          |> Enum.map(&%{&1 | sort: has_many_sort})
          |> Enum.reduce(dsl_state, fn has_many, dsl_state ->
            Transformer.replace_entity(
              dsl_state,
              [:relationships],
              has_many,
              &(&1.name == has_many.name)
            )
          end)

        {:ok, dsl_state}
    end
  end
end

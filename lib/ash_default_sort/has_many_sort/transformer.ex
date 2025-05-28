defmodule AshDefaultSort.HasManySort.Transformer do
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  @impl Spark.Dsl.Transformer
  def transform(dsl_state) do
    except = Transformer.get_option(dsl_state, [:default_sort], :except)

    case Transformer.get_option(dsl_state, [:default_sort], :has_many_sort) do
      [] ->
        dsl_state

      has_many_sort ->
        dsl_state
        |> Transformer.get_entities([:relationships])
        |> Enum.filter(&(&1.type == :has_many))
        |> Enum.reject(&(&1.default_sort || &1.sort))
        |> Enum.reject(&(&1.name in except))
        |> Enum.map(&%{&1 | default_sort: has_many_sort})
        |> Enum.reduce(dsl_state, fn has_many, dsl_state ->
          Transformer.replace_entity(
            dsl_state,
            [:relationships],
            has_many,
            &(&1.name == has_many.name)
          )
        end)
    end
    |> then(fn dsl_state -> {:ok, dsl_state} end)
  end
end

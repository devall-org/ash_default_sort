defmodule AshDefaultSort.Transformer do
  use Spark.Dsl.Transformer

  alias Spark.Dsl.Transformer
  alias Ash.Resource.Builder

  def after?(_), do: true

  def transform(dsl_state) do
    sort = Transformer.get_option(dsl_state, [:default_sort], :sort)

    include_primary_read? =
      Transformer.get_option(dsl_state, [:default_sort], :include_primary_read?)

    except = Transformer.get_option(dsl_state, [:default_sort], :except)

    dsl_state
    |> Transformer.get_entities([:actions])
    |> Enum.filter(&(&1.type == :read))
    |> Enum.reject(&(&1.name in except))
    |> Enum.reject(&(&1.primary? && !include_primary_read?))
    |> Enum.map(fn %Ash.Resource.Actions.Read{preparations: preparations} = read ->
      {:ok, preparation} = Builder.build_preparation({AshDefaultSort.Preparation, sort: sort})
      %Ash.Resource.Actions.Read{read | preparations: preparations ++ [preparation]}
    end)
    |> Enum.reduce(dsl_state, fn action, dsl_state ->
      Transformer.replace_entity(
        dsl_state,
        [:actions],
        action,
        &(&1.name == action.name)
      )
    end)
    |> then(fn dsl_state -> {:ok, dsl_state} end)
  end
end

defmodule AshDefaultSort.Sort.Preparation do
  use Ash.Resource.Preparation

  def prepare(query, [sort: sort], _context) do
    query
    |> Ash.Query.before_action(fn
      %Ash.Query{sort: [_ | _]} = sorted_query ->
        sorted_query

      %Ash.Query{sort: []} = unsorted_query ->
        unsorted_query |> Ash.Query.sort(sort)
    end)
  end
end

defmodule AshDefaultSort.SortTest do
  use ExUnit.Case, async: true

  defmodule Obj do
    use Ash.Resource,
      data_layer: Ash.DataLayer.Ets,
      domain: AshDefaultSort.TestDomain,
      extensions: [AshDefaultSort]

    attributes do
      uuid_v7_primary_key :id
      attribute :age, :integer, allow_nil?: false, public?: true
    end

    actions do
      defaults [:read, create: :*]
      read :list
    end

    default_sort do
      sort age: :desc
    end
  end

  test "pass" do
    for age <- Enum.concat(1..5//2, 2..5//2) do
      Ash.Changeset.for_create(Obj, :create, %{age: age}) |> Ash.create!()
    end

    assert [1, 3, 5, 2, 4] =
             Ash.Query.for_read(Obj, :read) |> Ash.read!() |> Enum.map(& &1.age)

    assert [5, 4, 3, 2, 1] =
             Ash.Query.for_read(Obj, :list) |> Ash.read!() |> Enum.map(& &1.age)
  end
end

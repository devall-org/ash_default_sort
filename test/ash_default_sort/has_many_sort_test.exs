alias AshDefaultSort.HasManySortTest, as: ThisTest

defmodule ThisTest.TodoList do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: AshDefaultSort.TestDomain,
    extensions: [AshDefaultSort]

  actions do
    defaults [:read, create: :*]

    update :add_task do
      require_atomic? false
      argument :task, :map, allow_nil?: false
      change manage_relationship(:task, :tasks, type: :create)
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :title, :string, allow_nil?: false, public?: true
  end

  relationships do
    has_many :tasks, ThisTest.Task
  end

  default_sort do
    has_many_sort priority: :asc
  end
end

defmodule ThisTest.Task do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: AshDefaultSort.TestDomain,
    extensions: [AshDefaultSort]

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :priority, :integer, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :todo_list, ThisTest.TodoList
  end

  default_sort do
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "pass" do
    params = %{title: "Todo List 1"}
    list = Ash.Changeset.for_create(ThisTest.TodoList, :create, params) |> Ash.create!()

    for priority <- Enum.concat(1..5//2, 2..5//2) do
      params = %{task: %{priority: priority}}
      Ash.Changeset.for_update(list, :add_task, params) |> Ash.update!()
    end

    list = Ash.load!(list, [:tasks])
    assert [1, 2, 3, 4, 5] = Enum.map(list.tasks, & &1.priority)
  end
end

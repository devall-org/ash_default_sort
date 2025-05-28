defmodule AshDefaultSort.HasManySortTest do
  use ExUnit.Case, async: true

  alias __MODULE__.{TodoList, Task}

  defmodule TodoList do
    use Ash.Resource,
      data_layer: Ash.DataLayer.Ets,
      domain: AshDefaultSort.TestDomain,
      extensions: [AshDefaultSort]

    attributes do
      uuid_v7_primary_key :id
      attribute :title, :string, allow_nil?: false, public?: true
    end

    relationships do
      has_many :tasks, Task
    end

    actions do
      defaults [:read, create: :*]

      update :add_task do
        require_atomic? false
        argument :task, :map, allow_nil?: false
        change manage_relationship(:task, :tasks, type: :create)
      end
    end

    default_sort do
      has_many_sort priority: :asc
    end
  end

  defmodule Task do
    use Ash.Resource,
      data_layer: Ash.DataLayer.Ets,
      domain: AshDefaultSort.TestDomain,
      extensions: [AshDefaultSort]

    attributes do
      uuid_v7_primary_key :id
      attribute :priority, :integer, allow_nil?: false, public?: true
    end

    relationships do
      belongs_to :todo_list, TodoList
    end

    actions do
      defaults [:read, create: :*]
    end

    default_sort do
    end
  end

  test "pass" do
    params = %{title: "Todo List 1"}
    list = Ash.Changeset.for_create(TodoList, :create, params) |> Ash.create!()

    for priority <- Enum.concat(1..5//2, 2..5//2) do
      params = %{task: %{priority: priority}}
      Ash.Changeset.for_update(list, :add_task, params) |> Ash.update!()
    end

    list = Ash.load!(list, [:tasks])
    assert [1, 2, 3, 4, 5] = Enum.map(list.tasks, & &1.priority)
  end
end

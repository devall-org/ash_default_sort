# AshDefaultSort

Configure a default sort to apply when a read action has no sort.

## Installation

Add `ash_default_sort` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ash_default_sort, "~> 0.2.0"}
  ]
end
```

## Usage

```elixir
defmodule Post do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Postgres,
    extensions: [AshDefaultSort]

  relationships do
    has_many :comments, Comment
    has_many :tags, :Tag do
      sort [id: :asc]
    end
  end

  actions do
    read :read do
      primary? true
    end
  
    read :read_sorted do
      prepare build(sort: [id: :desc])
    end

    read :read_all do
    end

    read :read_every do
    end
  end

  default_sort do
    sort [like_count: :desc, created_at: :desc]
    has_many_sort [id: :desc]
    include_primary_read? false
    except [:read_all]
  end
end
```

In the example above, [like_count: :desc, created_at: :desc] is applied to `read_every`.

This is because `read` is excluded by `include_primary_read? false`, `read_sorted` is not affected because it already includes a sort, and `read_all` is excluded by the `except` option.

And comments are sorted by [id: :desc] because `has_many_sort` is applied.

## License

MIT
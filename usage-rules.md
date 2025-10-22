# Rules for working with AshDefaultSort

## Purpose

AshDefaultSort is an Ash extension that applies default sorting to read actions and has_many relationships when no sort is specified.

## Basic Usage

```elixir
defmodule MyApp.Post do
  use Ash.Resource,
    extensions: [AshDefaultSort]

  default_sort do
    sort [created_at: :desc]
  end
end
```

The sort `[created_at: :desc]` will automatically apply to read actions that don't have a sort defined.

## Options

### sort

Default sort to apply to read actions.

```elixir
default_sort do
  sort [priority: :desc, created_at: :desc]
end
```

### has_many_sort

Default sort to apply to has_many relationships.

```elixir
default_sort do
  has_many_sort [position: :asc]
end
```

### include_primary_read?

Whether to apply the default sort to the primary read action. Defaults to `false`.

```elixir
default_sort do
  sort [created_at: :desc]
  include_primary_read? true
end
```

### except

List of read actions to exclude from default sorting.

```elixir
default_sort do
  sort [created_at: :desc]
  except [:read_all, :read_custom]
end
```

## Application Rules

Default sort is applied only when:

1. The read action doesn't already have a sort
2. Either `include_primary_read?` is true or the action is not the primary read
3. The action is not in the `except` list

For has_many relationships, `has_many_sort` applies when the relationship definition has no sort and the related resource has no default_sort.

## Complete Example

```elixir
defmodule MyApp.Post do
  use Ash.Resource,
    extensions: [AshDefaultSort]

  relationships do
    has_many :comments, MyApp.Comment
    has_many :tags, MyApp.Tag do
      sort [name: :asc]  # Already has sort, won't apply has_many_sort
    end
  end

  actions do
    read :read do
      primary? true
    end

    read :recent do
      # No sort -> default_sort applies
    end

    read :by_title do
      prepare build(sort: [title: :asc])  # Already has sort, won't apply
    end

    read :all do
      # In except list, won't apply
    end
  end

  default_sort do
    sort [like_count: :desc, created_at: :desc]
    has_many_sort [id: :desc]
    include_primary_read? false
    except [:all]
  end
end
```

In this example:
- `read` (primary): Not applied because include_primary_read? is false
- `recent`: Default sort applies
- `by_title`: Not applied because it already has a sort
- `all`: Not applied because it's in the except list
- `comments` relationship: has_many_sort applies
- `tags` relationship: Not applied because it already has a sort


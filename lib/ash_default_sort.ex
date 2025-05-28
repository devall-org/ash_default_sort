defmodule AshDefaultSort do
  @default_sort %Spark.Dsl.Section{
    name: :default_sort,
    describe: """
    Configure a default sort to apply when a read action has no sort.
    """,
    examples: [
      """
      default_sort do
        sort [user_id: :asc, created_at: :desc]
        include_primary_read? true
        except [:read_without_sort]
      end
      """
    ],
    schema: [
      sort: [
        type: :keyword_list,
        required: false,
        default: [],
        doc: "The sort to apply when Ash.Query has no sort"
      ],
      include_primary_read?: [
        type: :boolean,
        required: false,
        default: false,
        doc: "Whether to apply to the primary read action as well"
      ],
      except: [
        type: {:wrap_list, :atom},
        required: false,
        default: [],
        doc: "List of read actions to exclude"
      ],
      has_many_sort: [
        type: :keyword_list,
        required: false,
        default: [],
        doc: "The sort to apply when a has_many relationship has no sort"
      ]
    ],
    entities: []
  }

  use Spark.Dsl.Extension,
    sections: [@default_sort],
    transformers: [
      AshDefaultSort.Sort.Transformer,
      AshDefaultSort.HasManySort.Transformer
    ]
end

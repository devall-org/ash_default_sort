spark_locals_without_parens = [except: 1, has_many_sort: 1, include_primary_read?: 1, sort: 1]

[
  import_deps: [:spark, :reactor, :ash],
  inputs: [
    "{mix,.formatter}.exs",
    "{config,lib,test}/**/*.{ex,exs}"
  ],
  plugins: [Spark.Formatter],
  locals_without_parens: spark_locals_without_parens,
  export: [
    locals_without_parens: spark_locals_without_parens
  ]
]

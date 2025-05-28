import Config

config :ash, :validate_domain_config_inclusion?, false

env_config = "#{config_env()}.exs"

if Path.expand(env_config, __DIR__) |> File.exists?() do
  import_config env_config
end

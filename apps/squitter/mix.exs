defmodule Squitter.Mixfile do
  use Mix.Project

  def project do
    [app: :squitter,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: [:elixir_make] ++ Mix.compilers,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {Squitter.Application, []}]
  end

  defp deps do
    [{:gen_stage, "~> 0.11"},
     {:elixir_make, "~> 0.4", runtime: false},
     {:ringbuffer, github: "electricshaman/elixir-ringbuffer"}]
  end
end

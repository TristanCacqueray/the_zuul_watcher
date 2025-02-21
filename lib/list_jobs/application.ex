defmodule ListJobs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: ListJobs.Worker.start_link(arg)
      # {ListJobs.Worker, arg}
      {ListJobs.JobOutput, name: ListJobs.JobOutput},
      ListJobs.ZuulClient.child_spec(),
      ListJobs.ZuulStatus,
      {DynamicSupervisor, name: ListJobs.OngoingJobs, strategy: :one_for_one}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ListJobs.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

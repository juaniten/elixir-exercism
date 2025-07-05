# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []) do
    Agent.start(fn -> %{plots: [], last_id: 0} end, opts)
  end

  def list_registrations(pid) do
    Agent.get(pid, fn state -> state.plots end)
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn state ->
      %{plots: plots, last_id: last_id} = state
      new_id = last_id + 1
      new_plot = %Plot{plot_id: new_id, registered_to: register_to}
      new_state = %{plots: [new_plot | plots], last_id: new_id}
      {new_plot, new_state}
    end)
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn state ->
      new_plots = Enum.reject(state.plots, fn plot -> plot.plot_id == plot_id end)
      %{state | plots: new_plots}
    end)
  end

  def get_registration(pid, plot_id) do
    Agent.get(pid, fn state ->
      Enum.find(state.plots, {:not_found, "plot is unregistered"}, fn %Plot{plot_id: id} ->
        id == plot_id
      end)
    end)
  end
end

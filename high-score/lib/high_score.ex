defmodule HighScore do
  @default_initial_score 0

  def new(), do: %{}

  def add_player(scores, name, score \\ @default_initial_score), do: Map.put(scores, name, score)

  def remove_player(scores, name) do
    {_, new_map} = Map.pop(scores, name)
    new_map
  end

  def reset_score(scores, name), do: Map.put(scores, name, @default_initial_score)

  def update_score(scores, name, score), do: Map.update(scores, name, score, &(&1 + score))

  def get_players(scores), do: Map.keys(scores)
end

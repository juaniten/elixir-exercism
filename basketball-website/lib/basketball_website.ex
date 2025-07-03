defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    keys = String.split(path, ".")
    extract(data, keys)
  end

  defp extract(data, [key]), do: data[key]
  defp extract(data, [key | rest]), do: extract(data[key], rest)

  def get_in_path(data, path) do
    keys = String.split(path, ".")
    get_in(data, keys)
  end
end

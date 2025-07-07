defmodule GottaSnatchEmAll do
  @type card :: String.t()
  @type collection :: MapSet.t(card())

  @spec new_collection(card()) :: collection()
  def new_collection(card), do: MapSet.new([card])

  @spec add_card(card(), collection()) :: {boolean(), collection()}
  def add_card(card, collection),
    do: {MapSet.member?(collection, card), MapSet.put(collection, card)}

  @spec trade_card(card(), card(), collection()) :: {boolean(), collection()}
  def trade_card(your_card, their_card, collection) do
    {MapSet.member?(collection, your_card) and not MapSet.member?(collection, their_card),
     MapSet.delete(collection, your_card) |> MapSet.put(their_card)}
  end

  @spec remove_duplicates([card()]) :: [card()]
  def remove_duplicates(cards) do
    cards
    |> MapSet.new()
    |> MapSet.to_list()
    |> Enum.sort()
  end

  @spec extra_cards(collection(), collection()) :: non_neg_integer()
  def extra_cards(your_collection, their_collection) do
    MapSet.difference(your_collection, their_collection)
    |> Enum.count()
  end

  @spec boring_cards([collection()]) :: [card()]
  def boring_cards([]), do: []

  def boring_cards(collections) do
    [first | rest] = collections

    rest
    |> Enum.reduce(first, &MapSet.intersection/2)
    |> MapSet.to_list()
    |> Enum.sort()
  end

  @spec total_cards([collection()]) :: non_neg_integer()
  def total_cards(collections) do
    collections
    |> Enum.reduce(MapSet.new(), &MapSet.union/2)
    |> MapSet.to_list()
    |> Enum.count()
  end

  @spec split_shiny_cards(collection()) :: {[card()], [card()]}
  def split_shiny_cards(collection) do
    {collection
     |> MapSet.filter(&String.starts_with?(&1, "Shiny"))
     |> MapSet.to_list(),
     collection
     |> MapSet.reject(&String.starts_with?(&1, "Shiny"))
     |> MapSet.to_list()}
  end
end

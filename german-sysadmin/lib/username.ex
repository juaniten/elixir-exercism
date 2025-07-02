defmodule Username do
  def sanitize([]), do: ~c""

  def sanitize([head | tail]) do
    new_head =
      case head do
        head when head in ?a..?z or head == ?_ -> [head]
        ?ä -> ~c"ae"
        ?ö -> ~c"oe"
        ?ü -> ~c"ue"
        ?ß -> ~c"ss"
        _ -> []
      end

    new_head ++ sanitize(tail)
  end
end

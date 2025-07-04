defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end


  def decode_secret_message_part({operation, _meta, [{:when, _, [{name, _, args}, _guard]}, _body]} = ast, acc)
      when operation in [:def, :defp] do
    arity = length(args || [])
    prefix = name |> Atom.to_string() |> String.slice(0, arity)
    {ast, [prefix | acc]}
  end

  def decode_secret_message_part({operation, _meta, [{name, _, args}, _body]} = ast, acc)
      when operation in [:def, :defp] do
    arity = length(args || [])
    prefix = name |> Atom.to_string() |> String.slice(0, arity)
    {ast, [prefix | acc]}
  end

  def decode_secret_message_part(ast, acc), do: {ast, acc}


  def decode_secret_message(string) do
    {_new_ast, final_acc} = string
    |> to_ast()
    |> Macro.prewalk([], &decode_secret_message_part/2)

    final_acc |> Enum.reverse() |> Enum.join()
  end
end

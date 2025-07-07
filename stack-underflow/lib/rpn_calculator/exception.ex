defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception(value) do
      case value do
        [] ->
          %StackUnderflowError{}

        _ ->
          %StackUnderflowError{
            message: "stack underflow occurred, context: " <> value
          }
      end
    end
  end

  def divide(stack) when length(stack) < 2, do: raise(StackUnderflowError, "when dividing")
  def divide([0 | _]), do: raise(DivisionByZeroError)
  def divide(stack), do: Enum.at(stack, 1) / Enum.at(stack, 0)
end

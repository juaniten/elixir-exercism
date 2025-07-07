defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    pid = spawn_link(fn -> calculator.(input) end)
    %{input: input, pid: pid}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    receive do
      {:EXIT, from, :normal} when from == pid -> Map.put(results, input, :ok)
      {:EXIT, from, _reason} when from == pid -> Map.put(results, input, :error)
    after
      100 -> Map.put(results, input, :timeout)
    end
  end

  def reliability_check(calculator, inputs) do
    old_flag = Process.flag(:trap_exit, true)

    checks = Enum.map(inputs, &start_reliability_check(calculator, &1))

    results =
      Enum.reduce(checks, %{}, fn task_info, acc ->
        await_reliability_check_result(task_info, acc)
      end)

    Process.flag(:trap_exit, old_flag)

    results
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(fn input -> Task.async(fn -> calculator.(input) end) end)
    |> Enum.map(fn task -> Task.await(task, 100) end)
  end
end

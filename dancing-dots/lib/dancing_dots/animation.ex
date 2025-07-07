defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts :: opts) :: {:ok, opts} | {:error, error :: error}
  @callback handle_frame(dot :: dot, frame_number :: frame_number, opts :: opts) :: dot

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts), do: {:ok, opts}
      defoverridable(init: 1)
    end
  end
end

defmodule DancingDots.Flicker do
  alias DancingDots.Animation
  use Animation

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, _opts) when rem(frame_number, 4) == 0,
    do: %DancingDots.Dot{dot | opacity: dot.opacity / 2}

  @impl DancingDots.Animation
  def handle_frame(dot, _frame_number, _opts), do: dot
end

defmodule DancingDots.Zoom do
  alias DancingDots.Animation
  use Animation

  @impl DancingDots.Animation
  def init(opts) do
    case Keyword.fetch(opts, :velocity) do
      :error ->
        {:error, "The :velocity option is required, and its value must be a number. Got: nil"}

      {:ok, velocity} when is_number(velocity) ->
        {:ok, opts}

      {:ok, velocity} ->
        {:error,
         "The :velocity option is required, and its value must be a number. Got: #{inspect(velocity)}"}
    end
  end

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, opts) do
    {:ok, velocity} = Keyword.fetch(opts, :velocity)
    %DancingDots.Dot{dot | radius: dot.radius + (frame_number - 1) * velocity}
  end
end

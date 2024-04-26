defmodule FuelCalculator.CLI do
  @spec main(any()) :: any()
  def main(args \\ []) do
    FuelCalculator.call(parse_mass(args), constuct_path(args))
    |> output()
  end

  defp parse_mass([mass_arg | _]) do
    with {mass, _} <- Float.parse(mass_arg) do
      mass
    else
      _ -> 0
    end
  end
  defp parse_mass(_), do: 0

  defp parse_planets([_mass, pl]), do: [pl, pl]
  defp parse_planets([_mass | planets]), do: planets
  defp parse_planets(_), do: []

  defp constuct_path(args) do
    args
    |> parse_planets()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.flat_map(fn [p1, p2] -> [{:launch, p1}, {:land, p2}] end)
  end

  defp output({:error, error}) do
    IO.puts(error)
    exit({:shutdown, 1})
  end
  defp output(fuel), do: IO.puts(fuel)
end

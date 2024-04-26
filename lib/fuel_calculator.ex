defmodule FuelCalculator do
  @moduledoc """
  Documentation for `FuelCalculator`.
  """
  @gravity %{"earth" => 9.807, "moon" => 1.62, "mars" => 3.711}

  @doc """
  NASA Fuel Calculator.
  Calculate the fuel required for the flight.

  ## Examples

      iex> FuelCalculator.call(28801, [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}])
      51898

  """
  def call(mass, path) do
    with :ok <- valid_mass(mass), :ok <- known_planets(path), :ok <- valid_path(path) do
      calculate_fuel(mass, path)
    else
      err -> err
    end
  end

  defp valid_mass(mass) when is_number(mass) and mass > 0, do: :ok
  defp valid_mass(_), do: {:error, "Invalid mass"}

  defp known_planets([]), do: :ok
  defp known_planets([{_, planet} | tail]) when is_map_key(@gravity, planet), do: known_planets(tail)
  defp known_planets(_), do: {:error, "Unknown planet"}

  defp valid_path(path), do: valid_start(path) |> valid_connections()

  defp valid_start([{:launch, _} | _] = path), do: path
  defp valid_start(_), do: {:error, "Invalid path"}

  defp valid_connections({:error, _} = err), do: err
  defp valid_connections([{:launch, _}, {:land, p2} | tail]), do: valid_connections([{:land, p2} | tail])
  defp valid_connections([{:land, p1}, {:launch, p1} | tail]), do: valid_connections([{:launch, p1} | tail])
  defp valid_connections([{:land, _}]), do: :ok
  defp valid_connections(_), do: {:error, "Invalid path"}

  defp calculate_fuel(mass, path), do: calculate_fuel(0, mass, Enum.reverse(path))
  defp calculate_fuel(fuel, mass, [{dir, planet} | tail]) do
    fuel + dir_fuel(dir, mass + fuel, @gravity[planet])
    |> calculate_fuel(mass, tail)
  end
  defp calculate_fuel(fuel, _, _), do: fuel

  defp dir_fuel(:launch, mass, gravity), do: launch_fuel(mass, gravity)
  defp dir_fuel(:land, mass, gravity), do: landing_fuel(mass, gravity)

  defp launch_fuel(mass, gravity) when mass > 0 do
    (mass * gravity * 0.042 - 33) |> trunc() |> max(0) |> add_additional_fuel(gravity, &launch_fuel/2)
  end
  defp launch_fuel(_mass, _gravity), do: 0

  defp landing_fuel(mass, gravity) when mass > 0 do
    (mass * gravity * 0.033 - 42) |> trunc() |> max(0) |> add_additional_fuel(gravity, &landing_fuel/2)
  end
  defp landing_fuel(_mass, _gravity), do: 0

  defp add_additional_fuel(fuel, gravity, f), do: fuel + f.(fuel, gravity)
end

defmodule FuelCalculatorTest do
  use ExUnit.Case
  doctest FuelCalculator

  describe "Apollo 11" do
    test "calculate the fuel required for the journey" do
      mass = 28801
      path = [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}]
      assert FuelCalculator.call(mass, path) == 51898
    end
  end

  describe "Mission on Mars" do
    test "calculate the fuel required for the journey" do
      mass = 14606
      path = [{:launch, "earth"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]
      assert FuelCalculator.call(mass, path) == 33388
    end
  end

  describe "Passenger ship" do
    test "calculate the fuel required for the journey" do
      mass = 75432
      path = [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]
      assert FuelCalculator.call(mass, path) == 212161
    end
  end

  describe "Invalid mass argument" do
    test "returns error" do
      assert FuelCalculator.call("str", [{:launch, "earth"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]) == {:error, "Invalid mass"}
    end
  end

  describe "Invalid path argument" do
    test "returns error" do
      assert FuelCalculator.call(75432, [{:launch, "earth"}, {:launch, "moon"}, {:land, "mars"}]) == {:error, "Invalid path"}
      assert FuelCalculator.call(75432, [{:launch, "earth"}, {:land, "moon"}, {:launch, "mars"}]) == {:error, "Invalid path"}
      assert FuelCalculator.call(75432, [{:land, "earth"}, {:launch, "earth"}, {:land, "earth"}]) == {:error, "Invalid path"}
      assert FuelCalculator.call(75432, [{:land, "earth"}, {:land, "moon"}, {:launch, "moon"}]) == {:error, "Invalid path"}
    end
  end

  describe "Unknown planet" do
    test "returns error" do
      assert FuelCalculator.call(28801, [{:launch, "earth"}, {:land, "saturn"}, {:launch, "saturn"}, {:land, "earth"}]) == {:error, "Unknown planet"}
    end
  end
end

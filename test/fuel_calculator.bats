#!/usr/bin/env bats

@test "Apollo 11" {
  run ./fuel_calculator 28801 earth moon earth
  [ "$status" -eq 0 ]
  [ "$output" = "51898" ]
}

@test "Mission on Mars" {
  run ./fuel_calculator 14606 earth mars earth
  [ "$status" -eq 0 ]
  [ "$output" = "33388" ]
}

@test "Passenger ship" {
  run ./fuel_calculator 75432 earth moon mars earth
  [ "$status" -eq 0 ]
  [ "$output" = "212161" ]
}

@test "Unknown planet" {
  run ./fuel_calculator 75432 earth saturn
  [ "$status" -eq 1 ]
  [ "$output" = "Unknown planet" ]
}

@test "No arguments" {
  run ./fuel_calculator
  [ "$status" -eq 1 ]
  [ "$output" = "Invalid mass" ]
}

@test "Invalid mass" {
  run ./fuel_calculator none
  [ "$status" -eq 1 ]
  [ "$output" = "Invalid mass" ]
}

@test "No path provided" {
  run ./fuel_calculator 123
  [ "$status" -eq 1 ]
  [ "$output" = "Invalid path" ]
}

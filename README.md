# FuelCalculator

NASA Fuel Calculator: Application and CLI to calculate the fuel required for the flight.

## Installation

After checking out the repo, run `mix deps.get` to install dependencies. Then, run `mix test` to run the tests.

## Interactive prompt

Run `iex -S mix` for an interactive prompt that will allow you to experiment:

~~~elixir
iex(1)> FuelCalculator.call(28801, [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}])
51898
iex(2)> FuelCalculator.call(28801, [{:launch, "earth"}, {:launch, "moon"}, {:land, "earth"}])
{:error, "Invalid path"}
~~~

## CLI Installation

To create the executable command file, run `mix escript.build`. This overrides file `./fuel_calculator`. Create an alias in your bash profile file or a symlink to make the command globally available.

## CLI Usage

The CLI interface is simplified. The user specifies a mass of the ship (including equipment) and a list of planets, and the program plans an appropriate launch/land path for the mission and calculates the amount of fuel.

    $ ./fuel_calculator 28801 earth moon earth
    51898

## Install <abbr title="Bash Automated Testing System">BATS</abbr> for CLI testing

https://bats-core.readthedocs.io/en/stable/installation.html

## Run <abbr title="Bash Automated Testing System">BATS</abbr> tests

    $ bats test

## Uninstall CLI

Remove the alias or symlink.

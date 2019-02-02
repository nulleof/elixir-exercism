if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("tournament.exs", __DIR__)
end

ExUnit.start()
ExUnit.configure(trace: true, exclude: :pending)

defmodule TournamentTest do
  use ExUnit.Case

  test "results map creation, valid strings" do
    input = [
      "Allegoric Alaskans;Blithering Badgers;win",
      "Devastating Donkeys;Courageous Californians;draw",
      "Devastating Donkeys;Allegoric Alaskans;win",
      "Courageous Californians;Blithering Badgers;loss",
      "Blithering Badgers;Devastating Donkeys;loss",
      "Allegoric Alaskans;Courageous Californians;win"
    ]

    expected =  %{
              "Allegoric Alaskans" => %{D: 0, L: 1, W: 2, P: 6, MP: 3},
              "Blithering Badgers" => %{D: 0, L: 2, W: 1, P: 3, MP: 3},
              "Courageous Californians" => %{D: 1, L: 2, W: 0, P: 1, MP: 3},
              "Devastating Donkeys" => %{D: 1, L: 0, W: 2, P: 7, MP: 3}
            }

    assert Tournament.gen_result_map(input) == expected
  end

  test "result map creation, broken strings" do
    input = [
      "",
      "Allegoric Alaskans@Blithering Badgers;draw",
      "Blithering Badgers;Devastating Donkeys;lose",
      "Devastating Donkeys;Courageous Californians;win;5",
      "Courageous Californians;Allegoric Alaskans;loss"
    ]

    expected =  %{
              "Courageous Californians" => %{D: 0, L: 1, W: 0, P: 0, MP: 1},
              "Allegoric Alaskans" => %{D: 0, L: 0, W: 1, P: 3, MP: 1}
            }

    assert Tournament.gen_result_map(input) == expected
  end

  test "str_right_pad" do
    assert Tournament.str_right_pad("Team", 31) == "Team                           "
    assert Tournament.str_right_pad("Team", 5) == "Team "
    assert Tournament.str_right_pad("Team", 2) == "T "
  end

  test "str_center_pad" do
    assert Tournament.str_center_pad("", 4) == "    "
    assert Tournament.str_center_pad("5", 4) == "  5 "
    assert Tournament.str_center_pad("10", 4) == " 10 "
    assert Tournament.str_center_pad("WP", 4) == " WP "
    assert Tournament.str_center_pad("WPSSSZ", 4) == " WP "
  end

  test "gen_table_row" do
    assert Tournament.gen_table_row("Team", %{MP: "MP", W: "W", D: "D", L: "L", P: "P"}) == "Team                           | MP |  W |  D |  L |  P\n"
    assert Tournament.gen_table_row("Devastating Donkeys", %{MP: 3, W: 2, D: 1, L: 0, P: 7}) == "Devastating Donkeys            |  3 |  2 |  1 |  0 |  7\n"
  end

  test "get_first_team" do
    input_map = %{
      "Blithering Badgers" => %{D: 0, L: 1, W: 0, P: 0, MP: 1},
      "Devastating Donkeys" => %{D: 0, L: 0, W: 1, P: 3, MP: 1}
    }

    assert Tournament.get_first_team(input_map) == "Devastating Donkeys"

    input = %{
      "Blithering Badgers" => %{D: 0, L: 1, W: 0, P: 3, MP: 1},
      "Devastating Donkeys" => %{D: 0, L: 0, W: 1, P: 3, MP: 1}
    }
    assert Tournament.get_first_team(input) == "Blithering Badgers"
  end

  test "gen_table_for_teams" do
    input_map = %{
      "Blithering Badgers" => %{D: 0, L: 1, W: 0, P: 0, MP: 1},
    }
    assert Tournament.gen_table_for_teams("", input_map) == "Blithering Badgers             |  1 |  0 |  0 |  1 |  0\n"

    input_map = %{
      "Blithering Badgers" => %{D: 0, L: 1, W: 0, P: 0, MP: 1},
    }
    assert Tournament.gen_table_for_teams("Team                           | MP |  W |  D |  L |  P\n", input_map) ==  """
      Team                           | MP |  W |  D |  L |  P
      Blithering Badgers             |  1 |  0 |  0 |  1 |  0
      """

    input_map = %{
      "Blithering Badgers" => %{D: 0, L: 1, W: 0, P: 0, MP: 1},
      "Devastating Donkeys" => %{D: 0, L: 0, W: 1, P: 3, MP: 1}
    }
    assert Tournament.gen_table_for_teams("", input_map) == """
      Devastating Donkeys            |  1 |  1 |  0 |  0 |  3
      Blithering Badgers             |  1 |  0 |  0 |  1 |  0
      """

    input_map = %{
      "Blithering Badgers" => %{D: 0, L: 1, W: 0, P: 0, MP: 1},
      "Devastating Donkeys" => %{D: 0, L: 0, W: 1, P: 3, MP: 1}
    }
    assert Tournament.gen_table_for_teams("Team                           | MP |  W |  D |  L |  P\n", input_map) == """
      Team                           | MP |  W |  D |  L |  P
      Devastating Donkeys            |  1 |  1 |  0 |  0 |  3
      Blithering Badgers             |  1 |  0 |  0 |  1 |  0
      """
  end

  # @tag :pending
  test "typical input" do
    input = [
      "Allegoric Alaskans;Blithering Badgers;win",
      "Devastating Donkeys;Courageous Californians;draw",
      "Devastating Donkeys;Allegoric Alaskans;win",
      "Courageous Californians;Blithering Badgers;loss",
      "Blithering Badgers;Devastating Donkeys;loss",
      "Allegoric Alaskans;Courageous Californians;win"
    ]

    expected =
      """
      Team                           | MP |  W |  D |  L |  P
      Devastating Donkeys            |  3 |  2 |  1 |  0 |  7
      Allegoric Alaskans             |  3 |  2 |  0 |  1 |  6
      Blithering Badgers             |  3 |  1 |  0 |  2 |  3
      Courageous Californians        |  3 |  0 |  1 |  2 |  1
      """
      |> String.trim()

    assert Tournament.tally(input) == expected
  end

  # @tag :pending
  test "incomplete competition (not all pairs have played)" do
    input = [
      "Allegoric Alaskans;Blithering Badgers;loss",
      "Devastating Donkeys;Allegoric Alaskans;loss",
      "Courageous Californians;Blithering Badgers;draw",
      "Allegoric Alaskans;Courageous Californians;win"
    ]

    expected =
      """
      Team                           | MP |  W |  D |  L |  P
      Allegoric Alaskans             |  3 |  2 |  0 |  1 |  6
      Blithering Badgers             |  2 |  1 |  1 |  0 |  4
      Courageous Californians        |  2 |  0 |  1 |  1 |  1
      Devastating Donkeys            |  1 |  0 |  0 |  1 |  0
      """
      |> String.trim()

    assert Tournament.tally(input) == expected
  end

  # @tag :pending
  test "ties broken alphabetically" do
    input = [
      "Courageous Californians;Devastating Donkeys;win",
      "Allegoric Alaskans;Blithering Badgers;win",
      "Devastating Donkeys;Allegoric Alaskans;loss",
      "Courageous Californians;Blithering Badgers;win",
      "Blithering Badgers;Devastating Donkeys;draw",
      "Allegoric Alaskans;Courageous Californians;draw"
    ]

    expected =
      """
      Team                           | MP |  W |  D |  L |  P
      Allegoric Alaskans             |  3 |  2 |  1 |  0 |  7
      Courageous Californians        |  3 |  2 |  1 |  0 |  7
      Blithering Badgers             |  3 |  0 |  1 |  2 |  1
      Devastating Donkeys            |  3 |  0 |  1 |  2 |  1
      """
      |> String.trim()

    assert Tournament.tally(input) == expected
  end

  # @tag :pending
  test "mostly invalid lines" do
    # Invalid input lines in an otherwise-valid game still results in valid
    # output.
    input = [
      "",
      "Allegoric Alaskans@Blithering Badgers;draw",
      "Blithering Badgers;Devastating Donkeys;loss",
      "Devastating Donkeys;Courageous Californians;win;5",
      "Courageous Californians;Allegoric Alaskans;los"
    ]

    expected =
      """
      Team                           | MP |  W |  D |  L |  P
      Devastating Donkeys            |  1 |  1 |  0 |  0 |  3
      Blithering Badgers             |  1 |  0 |  0 |  1 |  0
      """
      |> String.trim()

    assert Tournament.tally(input) == expected
  end
end

defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    result_map = gen_result_map(input)
  end

  def gen_result_map(lines) do
    Enum.reduce(lines, %{}, fn(x, acc) -> add_line_to_map(acc, x) end)
  end

  def get_old_team_results(map, team) do
    if(Map.has_key?(map, team)) do
      map[team]
    else
      %{MP: 0, W: 0, D: 0, L: 0, P: 0}
    end
  end

  def update_team_results(old_results = %{MP: mp_num, W: w_num, D: d_num, L: l_num, P: p_num}, action) do
    case action do
      :win -> %{old_results | W: w_num + 1, P: p_num + 3 }
      :lose -> %{old_results | L: l_num + 1}
      :draw -> %{old_results | D: d_num + 1, P: p_num + 1 }
    end
    |> (&%{&1 | MP: mp_num + 1}).()
  end

  def insert_result(map, team, action) do
    updated_entry = get_old_team_results(map, team)
    |> update_team_results(action)

    Map.put(map, team, updated_entry)
  end

  def add_line_to_map(map, line) do
    case String.split(line, ";") do
      [team_1, team_2, "win"] -> insert_result(map, team_1, :win) |> insert_result(team_2, :lose)
      [team_1, team_2, "lose"] -> insert_result(map, team_1, :lose) |> insert_result(team_2, :win)
      [team_1, team_2, "draw"] -> insert_result(map, team_1, :draw) |> insert_result(team_2, :draw)
      _ -> map
    end
  end
end

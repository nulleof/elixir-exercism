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

    # next we should generate output table

    res_str = gen_table_row("Team", %{MP: "MP", W: "W", D: "D", L: "L", P: "P"})
  end

  @spec get_spaces(input :: Integer.t()) :: String.t()
  def get_spaces(length) do
    if length <= 0,
    do: "",
    else: " " <> get_spaces(length - 1)
  end

  @spec str_right_pad(input :: String.t(), input :: Integer.t()) :: String.t()
  def str_right_pad(str, res_length) do
    str = String.trim(str)

    str_len = String.length(str)

    str = if(str_len <= res_length - 1) do
      str
    else
      String.slice(str, 0, res_length - 1)
    end

    # set new str length here again
    str_len = String.length(str)

    # I should use String.pad_leading or String.pad_trailing
    str <> get_spaces(res_length - str_len)
  end

  def str_center_pad(str, res_length, is_last \\ :false)

  def str_center_pad(str, res_length, is_last) when is_integer(str) do
    str_center_pad(Integer.to_string(str), res_length, is_last)
  end

  @spec str_center_pad(String.t(), Integer.t(), Boolean.t()) :: String.t()
  def str_center_pad(str, res_length, is_last) do
    # we want to make string padded to right AND add a space in the end
    # Or nothing, if is_last is true.

    str = String.trim(str)
    meaning_length = res_length - 1

    str = if (String.length(str) <= meaning_length - 1) do
      str
    else
      String.slice(str, 0, meaning_length - 1)
    end

    str_len = String.length(str)

    # I should use String.pad_leading or String.pad_trailing
    str = get_spaces(meaning_length - str_len) <> str

    if(is_last) do
      str <> "\n"
    else
      str <> " "
    end
  end

  @spec gen_table_row(input :: String.t(), input :: Map.t()) :: String.t()
  def gen_table_row(team, %{MP: mp_num, W: w_num, D: d_num, L: l_num, P: p_num}) do
    str_right_pad(team, 31)
    <> "|" <>
    str_center_pad(mp_num, 4)
    <> "|" <>
    str_center_pad(w_num, 4)
    <> "|" <>
    str_center_pad(d_num, 4)
    <> "|" <>
    str_center_pad(l_num, 4)
    <> "|" <>
    str_center_pad(p_num, 4, :true)
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

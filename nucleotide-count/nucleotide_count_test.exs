if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("nucleotide_count.exs", __DIR__)
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule NucleotideCountTest do
  use ExUnit.Case

  # @tag :pending
  test "empty_map()" do
    assert NucleotideCount.empty_map() == %{?A => 0, ?T => 0, ?C => 0, ?G => 0}
  end

  # @tag :pending
  test "generate map on char array" do
    assert NucleotideCount.histogram('') == %{?A => 0, ?T => 0, ?C => 0, ?G => 0}
    assert NucleotideCount.histogram('ACGT') == %{?A => 1, ?T => 1, ?C => 1, ?G => 1}
    assert NucleotideCount.histogram('ACCCCCCGTTTT') == %{?A => 1, ?T => 4, ?C => 6, ?G => 1}
  end

  # @tag :pending
  test "empty dna string has no adenine" do
    assert NucleotideCount.count('', ?A) == 0
  end

  # @tag :pending
  test "repetitive cytosine gets counted" do
    assert NucleotideCount.count('CCCCC', ?C) == 5
  end

  # @tag :pending
  test "counts only thymine" do
    assert NucleotideCount.count('GGGGGTAACCCGG', ?T) == 1
  end

  # @tag :pending
  test "empty dna string has no nucleotides" do
    expected = %{?A => 0, ?T => 0, ?C => 0, ?G => 0}
    assert NucleotideCount.histogram('') == expected
  end

  # @tag :pending
  test "repetitive sequence has only guanine" do
    expected = %{?A => 0, ?T => 0, ?C => 0, ?G => 8}
    assert NucleotideCount.histogram('GGGGGGGG') == expected
  end

  # @tag :pending
  test "counts all nucleotides" do
    s = 'AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC'
    expected = %{?A => 20, ?T => 21, ?C => 12, ?G => 17}
    assert NucleotideCount.histogram(s) == expected
  end
end

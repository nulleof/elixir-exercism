defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """
  use Agent

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  def start_link do
    Agent.start_link(fn -> %{balance: 0, opened: true} end)
  end

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, acc} = start_link
    acc
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    Agent.update(account, fn bank_account -> %{bank_account | opened: false} end)
  end

  defp get_bank_account(account) do
    acc = Agent.get(account, &(&1))
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    #
    # why doesn't is work?
    #
    # acc = get_bank_account(account)
    #
    # cond do
    #   %{opened: false} = acc -> {:error, :account_closed}
    #   true -> acc.balance
    # end

    acc = get_bank_account account

    case acc do
      %{opened: false} -> {:error, :account_closed}
      %{balance: balance} -> balance
    end
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    acc = get_bank_account account

    case acc do
      %{opened: false} -> {:error, :account_closed}
      %{balance: balance} -> Agent.update(account, fn bank_account -> %{bank_account | balance: bank_account.balance + amount}  end)
    end
  end
end

defmodule ExChain.Blockchain do
  @moduledoc """
  This module contains the blockchain related functions
  """

  alias __MODULE__
  alias ExChain.Blockchain.Block

  defstruct ~w(chain)a

  @type t :: %Blockchain{
          chain: [Block.t()]
        }

  @spec new :: Blockchain.t()
  def new() do
    %__MODULE__{}
    |> add_genesis()
  end

  @spec add_block(Blockchain.t(), any()) :: Blockchain.t()
  def add_block(blockchain = %__MODULE__{chain: chain}, data) do
    {last_block, _} = List.pop_at(chain, -1)

    %{blockchain | chain: chain ++ [Block.mine_block(last_block, data)]}
  end

  @spec valid_chain?(Blockchain.t()) :: boolean()
  def valid_chain?(%__MODULE__{chain: chain}) do
    chain
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [prev_block, block] ->
      valid_last_hash?(prev_block, block) && valid_block_hash?(prev_block)
    end)
  end

  # private functions
  defp add_genesis(%__MODULE__{} = blockchain), do: %{blockchain | chain: [Block.genesis()]}

  defp valid_last_hash?(%Block{hash: hash}, %Block{last_hash: last_hash}), do: hash == last_hash

  defp valid_block_hash?(%Block{hash: hash} = block), do: hash == Block.block_hash(block)
end

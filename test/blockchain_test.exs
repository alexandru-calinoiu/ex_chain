defmodule ExChain.BlockchainTest do
  @moduledoc """
  This module contains test related to a blockchain
  """

  use ExUnit.Case

  alias ExChain.Blockchain
  alias ExChain.Blockchain.Block

  describe "Blockchain" do
    setup [:init_blockchain]

    test "sholud start with the genesis block", %{blockchain: blockchain} do
      assert Block.genesis() == hd(blockchain.chain)
    end

    test "adds a new block", %{blockchain: blockchain} do
      data = "foo"
      blockchain = Blockchain.add_block(blockchain, data)
      [_, block] = blockchain.chain
      assert block.data == data
    end
  end

  defp init_blockchain(context), do: Map.put(context, :blockchain, Blockchain.new())
end

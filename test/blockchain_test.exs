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

    test "validate blockchain", %{blockchain: blockchain} do
      blockchain = Blockchain.add_block(blockchain, "some-block-data")
      assert Blockchain.valid_chain?(blockchain)
    end

    test "when temper data in existing chain", %{blockchain: blockchain} do
      blockchain =
        blockchain
        |> Blockchain.add_block("data-block-1")
        |> Blockchain.add_block("data-block-2")
        |> Blockchain.add_block("data-block-3")

      assert Blockchain.valid_chain?(blockchain)

      index = 2
      tempered_block = put_in(Enum.at(blockchain.chain, index).data, "tempered_data")

      blockchain = %Blockchain{chain: List.replace_at(blockchain.chain, index, tempered_block)}

      refute Blockchain.valid_chain?(blockchain)
    end
  end

  defp init_blockchain(context), do: Map.put(context, :blockchain, Blockchain.new())
end

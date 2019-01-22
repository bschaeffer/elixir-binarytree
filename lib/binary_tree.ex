defmodule BinaryTree do
  @moduledoc """
  A Binary Tree

  Not self-balancing.
  """

  defmodule Node do
    @moduledoc """
    Struct representing a node in a binary tree.
    """
    @type value :: any()
    @type t :: %__MODULE__{left: nil | t(), right: nil | t(), value: value()}

    defstruct left: nil, value: nil, right: nil
  end

  @doc """
  Builds a tree from a list and returns the root node.
  """
  @spec from_list(list()) :: Node.t()
  def from_list([root | rest]) do
    Enum.reduce(rest, %Node{value: root}, &insert(&2, &1))
  end

  @doc """
  Inserts an item into the given node's tree. Returns the given node.
  """
  @spec insert(Node.t() | nil, Node.value()) :: Node.t()
  def insert(nil, value), do: %Node{value: value}
  def insert(node = %Node{}, value) do
    cond do
      value < node.value -> %{node | left: insert(node.left, value) }
      value > node.value -> %{node | right: insert(node.right, value) }
      true -> node
    end
  end

  @doc """
  Deletes an item, if it exists, from the given nodes tree. Returns the given node.
  """
  @spec delete(Node.t(), Node.value()) :: Node.t()
  def delete(node = %Node{}, value), do: del(node, value)

  @doc """
  Returns the minimum value under the given tree.
  """
  @spec min(Node.t() | nil) :: Node.value() | nil
  def min(nil), do: nil
  def min(%Node{left: nil, value: value}), do: value
  def min(%Node{left: left}), do: min(left)

  @doc """
  Returns the maximum value under the given tree.
  """
  def max(nil), do: nil
  def max(%Node{value: value, right: nil}), do: value
  def max(%Node{right: right}), do: max(right)

  @doc """
  Checks if an item exists on the tree?
  """
  @spec exists?(Node.t(), Node.value()) :: boolean()
  def exists?(node = %Node{}, value) do
    case find(node, value) do
      %Node{} -> true
      _ -> false
    end
  end

  @doc """
  Returns the node at the given value if it exists. Otherwise, it returns nil.
  """
  @spec find(Node.t() | nil, Node.value()) :: Node.t() | nil
  def find(nil, _), do: nil
  def find(node = %Node{}, value) do
    cond do
      value == node.value -> node
      value < node.value  -> find(node.left, value)
      value > node.value  -> find(node.right, value)
    end
  end

  @doc """
  Returns the height of the tree. Returns -1
  """
  @spec height(Node.t() | nil) :: integer()
  def height(nil), do: -1
  def height(node = %Node{}) do
    l = height(node.left)
    r = height(node.right)
    cond do
      l > r -> l + 1
      true  -> r + 1
    end
  end

  defp del(nil, _), do: nil
  defp del(node, value) do
    cond do
      value < node.value  -> %{node | left: del(node.left, value)}
      value > node.value  -> %{node | right: del(node.right, value)}
      value == node.value -> del(node)
    end
  end

  defp del(%Node{left: nil, right: right}), do: right
  defp del(%Node{left: left, right: nil}), do: left
  defp del(node = %Node{}) do
    min_right = min(node.right)
    %Node{left: node.left, value: min_right, right: del(node.right, min_right)}
  end
end

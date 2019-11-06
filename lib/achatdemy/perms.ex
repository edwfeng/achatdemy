defmodule Achatdemy.Perms do
  use Bitwise

  def perms do
    %{
      create_msg: 1,
      mod_msg: 2,
      create_chat: 4,
      mod_chat: 8,
      mod_comm: 16,
      admin: 32
    }
  end

  def get_perm_map(input) when is_integer(input) do
    case has_raw_perm?(input, :admin) do
      true ->
        perms()
        |> Map.new(fn {level, _} -> {level, true} end)
      false ->
        get_raw_perm_map(input)
    end
  end

  def get_raw_perm_map(input) when is_integer(input) do
    perms()
    |> Map.new(fn {level, num} -> {level, (input &&& num) != 0} end)
  end

  def has_perm?(input, perm) when is_integer(input) do
    input
    |> get_perm_map()
    |> Map.get(perm)
  end

  def has_raw_perm?(input, perm) when is_integer(input) do
    input
    |> get_raw_perm_map()
    |> Map.get(perm)
  end

  def create_perms(input) when is_map(input) do
    input
    |> Enum.filter(fn {_, val} -> val end)
    |> Enum.map(fn {perm, _} -> perms()[perm] end)
    |> Enum.sum()
  end

  def changeset(input, new) when is_integer(input) and is_map(new) do
    input
    |> get_raw_perm_map()
    |> Map.merge(new)
    |> create_perms()
  end
end

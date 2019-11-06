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
    perms()
    |> Enum.map(fn {level, num} -> {level, (input &&& num) != 0} end)
  end

  def has_perm?(input, perm) when is_integer(input) do
    (input &&& perms()[perm]) != 0
  end

  def create_perms(input) do
    case :admin in input do
      true ->
        perms()
        |> Enum.map(fn {_, num} -> num end)
        |> Enum.sum()
      false ->
        input
        |> Enum.map(fn perm -> perms()[perm] end)
        |> Enum.sum()
    end
  end
end

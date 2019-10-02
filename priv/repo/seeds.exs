# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Achatdemy.Repo.insert!(%Achatdemy.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Achatdemy.Repo.insert!(%Achatdemy.Users.User{
  username: "Anthony",
  password: "pass1",
  email: "anthony@example.com"
})

Achatdemy.Repo.insert!(%Achatdemy.Users.User{
  username: "Jeremy",
  password: "pass2",
  email: "jeremy@example.com"
})

Achatdemy.Repo.insert!(%Achatdemy.Comms.Comm{
  name: "Default Comm"
})

Achatdemy.Repo.insert!(%Achatdemy.Users.Perm{
  chmod: << 1 >>,
  user_id: 1,
  comm_id: 1
})

Achatdemy.Repo.insert!(%Achatdemy.Users.Perm{
  chmod: << 1 >>,
  user_id: 2,
  comm_id: 1
})

Achatdemy.Repo.insert!(%Achatdemy.Chats.Chat{
  title: "This is a chat",
  type: 3,
  author_id: 1,
  comm_id: 1
})

Achatdemy.Repo.insert!(%Achatdemy.Messages.Message{
  msg: "First!",
  chat_id: 1,
  author_id: 1
})

Achatdemy.Repo.insert!(%Achatdemy.Messages.Message{
  msg: "Not first...",
  chat_id: 1,
  author_id: 2
})

msg = Achatdemy.Repo.insert!(%Achatdemy.Messages.Message{
  msg: "Test with file",
  chat_id: 1,
  author_id: 1
}) |> Achatdemy.Repo.preload(:files)

file = Achatdemy.Repo.insert!(%Achatdemy.Messages.File{
  name: "Not a virus",
  path: "/usr/lib/virus"
}) |> Achatdemy.Repo.preload(:messages)

Ecto.Changeset.change(msg)
|> Ecto.Changeset.put_assoc(:files, [file])
|> Achatdemy.Repo.update!()

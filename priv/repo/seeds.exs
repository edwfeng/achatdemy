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

alias Achatdemy.Users.User
alias Achatdemy.Comms.Comm
alias Achatdemy.Chats.Chat
alias Achatdemy.Chats.Widget
alias Achatdemy.Messages.File
alias Achatdemy.Messages.Message

alias Achatdemy.Repo

user1 = %User{
  username: "Anthony",
  password: "pass1",
  email: "anthony@example.com"
} |> Repo.insert!

user2 = %User{
  username: "Jeremy",
  password: "pass2",
  email: "jeremy@example.com"
} |> Repo.insert!

comm1 = %Comm{
  name: "Default Comm"
} |> Repo.insert!

Achatdemy.Users.link_user_comm(user1.id, comm1.id, %{chmod: 1})
Achatdemy.Users.link_user_comm(user2.id, comm1.id, %{chmod: 0})

chat1 = %Chat{
  title: "This is a chat",
  type: 3,
  user_id: user1.id,
  comm_id: comm1.id
} |> Repo.insert!

_message1 = %Message{
  msg: "First!",
  chat_id: chat1.id,
  user_id: user1.id,
} |> Repo.insert!

_message2 = %Message{
  msg: "Not first...",
  chat_id: chat1.id,
  user_id: user2.id
} |> Repo.insert!

message3 = %Message{
  msg: "Test with file",
  chat_id: chat1.id,
  user_id: user1.id
} |> Repo.insert!

file1 = %File{
  name: "Not a virus",
  path: "/usr/lib/virus",
  message_id: message3.id
} |> Repo.insert!

_widget1 = %Widget{
  desc: "A widget",
  uri: "scheme:[//authority]path[?query][#fragment]",
  chat_id: chat1.id
} |> Repo.insert

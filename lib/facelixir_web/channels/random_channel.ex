defmodule FacelixirWeb.RandomChannel do
  use FacelixirWeb, :channel

  def join("random", payload, socket) do
    if authorized?(payload) do
      send self(), :after_join
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
  
  def handle_info(:after_join, socket) do
    messages =
      Facelixir.Conversations.list_messages()
      |> Enum.map(fn(m) -> %{message: m.message, name: m.name, age: m.age} end)

    push socket, "messages_history", %{messages: messages}
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (random).
  def handle_in("shout", payload, socket) do
    spawn(Facelixir.Conversations, :create_message, [payload])
    broadcast! socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

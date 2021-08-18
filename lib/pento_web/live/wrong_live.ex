defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(score: 0, message: "Guess a number.", answer: :rand.uniform(10))}
  end

  def render(assigns) do
    ~L"""
      <h1>Your Score: <%= @score %></h1>
      <h2>
        <%= @message%>
        It's <%= time() %>
      </h2>
      <h2>
        <%= for n <- 1..10 do %>
          <a href="#" phx-click="guess" phx-value-number="<%= n %>">
            <%= n %>
          </a>
        <% end %>
      </h2>
    """
  end

  def handle_event("guess", %{"number" => guess} = data, socket) do
    IO.inspect(data)
    IO.inspect(socket.assigns.answer, label: "answer??")

    {score, message, answer} =
      if guess == "#{socket.assigns.answer}" do
        {socket.assigns.score + 1, "Youre guess: #{guess}. Correct! Here, have a point.",
         :rand.uniform(10)}
      else
        {socket.assigns.score - 1, "Youre guess: #{guess}. Wrong. Try again.",
         socket.assigns.answer}
      end

    {:noreply, assign(socket, message: message, score: score, answer: answer)}
  end

  def time() do
    DateTime.utc_now() |> to_string
  end
end

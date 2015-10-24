defmodule Gaze.GazeController do
  use Gaze.Web, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end

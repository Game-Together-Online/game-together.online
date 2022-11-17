defmodule GameTogetherOnlineWeb.Administration.PageController do
  use GameTogetherOnlineWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

defmodule GameTogetherOnlineWeb.Live.Components.Spyfall.LobbyTest do
  use GameTogetherOnline.DataCase
  import Phoenix.LiveViewTest

  import GameTogetherOnline.Administration.PlayersFixtures
  alias GameTogetherOnlineWeb.Components.Spyfall.Lobby
  alias GameTogetherOnline.Administration.GameTypesFixtures
  alias GameTogetherOnline.Administration.SpyfallParticipantsFixtures
  alias GameTogetherOnline.Tables

  test "shows the table id" do
    player = player_fixture()
    spyfall = GameTypesFixtures.game_type_fixture(%{slug: "spyfall"})

    {:ok, table} = Tables.create_table(spyfall, %{})
    table = Tables.get_table!(table.id)

    assert render_component(Lobby,
             table: table,
             current_player: player,
             current_tab: "chat",
             myself: nil
           ) =~
             table.id
  end

  test "shows the join table button when the current user is not at the table" do
    player = player_fixture()
    spyfall = GameTypesFixtures.game_type_fixture(%{slug: "spyfall"})

    {:ok, table} = Tables.create_table(spyfall, %{})
    table = Tables.get_table!(table.id)

    spyfall_lobby =
      render_component(Lobby,
        table: table,
        current_player: player,
        current_tab: "chat",
        myself: nil
      )

    assert spyfall_lobby =~ "Join The Game"
    refute spyfall_lobby =~ "Leave The Game"
  end

  test "shows the leave table button when the current user is at the table" do
    player = player_fixture()
    spyfall = GameTypesFixtures.game_type_fixture(%{slug: "spyfall"})

    {:ok, table} = Tables.create_table(spyfall, %{})

    SpyfallParticipantsFixtures.spyfall_participant_fixture(%{
      player_id: player.id,
      spyfall_game_id: table.spyfall_game.id
    })

    table = Tables.get_table!(table.id)

    spyfall_lobby =
      render_component(Lobby,
        table: table,
        current_player: player,
        current_tab: "chat",
        myself: nil
      )

    refute spyfall_lobby =~ "Join The Game"
    assert spyfall_lobby =~ "Leave The Game"
  end
end

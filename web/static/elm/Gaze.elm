module Gaze where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Gaze.System exposing (..)

-- MODEL

type Tab = System | LoadCharts | Applications

type alias Model = { selected: Tab, system: Gaze.System.SystemRecord }

type Action =
  NoOp |
  SelectTab Tab |
  SystemUpdate Gaze.System.SystemRecord

port systemChannel : Signal SystemRecord

initialModel : Model
initialModel =
  { selected = System,
    system = Gaze.System.initialModel
  }

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp

actions : Signal Action
actions =
  Signal.merge inbox.signal (Signal.map SystemUpdate systemChannel)

model : Signal Model
model =
  Signal.foldp update initialModel actions

-- UPDATE

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    SelectTab tab ->
      { model | selected <- tab }
    SystemUpdate system ->
      { model | system <- system }

-- VIEW

renderNavTab : Signal.Address Action -> Model -> Tab -> Html
renderNavTab address model tab =
  let
    label tab =
      case tab of
        System ->
          text "System"
        LoadCharts ->
          text "Load charts"
        Applications ->
          text "Applications"
  in
    li [ classList [ ("active", (model.selected == tab)) ] ]
       [ a [ href "#", onClick address (SelectTab tab)] [ label tab ]]

renderNav : Signal.Address Action -> Model -> Html
renderNav address model =
  div [ class "navbar navbar-default" ] [
    div [ class "container" ] [
      div [ class "navbar-header"] [
        a [ class "navbar-brand", href "/gaze"] [ text "Gaze"]
      ],
      div [ class "collapse navbar-collapse", id "navbar-collapse" ] [
        ul [ class "nav navbar-nav" ]
          (List.map (renderNavTab address model) [System, LoadCharts, Applications])
      ]
    ]
  ]

renderMissing : Html
renderMissing =
  div [ class "container" ] [
    div [ class "jumbotron" ] [
      h2 [] [ text "Coming soon" ]
    ]
  ]

renderContainer : Model -> Html
renderContainer model =
  case model.selected of
    System ->
      Gaze.System.render model.system
    LoadCharts ->
      renderMissing
    Applications ->
      renderMissing

renderModel : Model -> Html
renderModel model =
  div [] [
    pre [] [ text (toString model) ]
  ]

view : Signal.Address Action -> Model -> Html
view address model =
  div [] [
    renderNav address model,
    renderContainer model
    -- renderModel model
  ]

-- MAIN

main : Signal Html
main =
  Signal.map (view inbox.address) model

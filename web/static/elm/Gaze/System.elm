module Gaze.System where

import Html exposing (..)
import Html.Attributes exposing (..)

systemLabels = [
    "System Version:",
    "Erts Version:",
    "Compiled for:",
    "Emulator Wordsize:",
    "Process Wordside:",
    "Smp Support:",
    "Thread Support:",
    "Async thread pool size:"
  ]
memoryLabels = [
    "Total:",
    "Processes:",
    "Atoms:",
    "Binaries:",
    "Code:",
    "Ets:"
  ]
cpusLabels = [
    "Logical CPU's:",
    "Online Logical CPU's:",
    "Available Logical CPU's:",
    "Schedulers:",
    "Online schedulers:",
    "Available schedulers:"
  ]
statisticsLabels = [
    "Up time:",
    "Max Processes:",
    "Processes:",
    "Run Queue:",
    "IO Input:",
    "IO Output:"
  ]

-- MODEL

type alias SystemPanel = List String
type alias SystemPanels = (SystemPanel, SystemPanel, SystemPanel, SystemPanel)
type alias SystemAlloc = List (String, String, String)
type alias SystemRecord = { panels: SystemPanels, alloc: SystemAlloc }

initialModel : SystemRecord
initialModel =
  SystemRecord ([], [], [], []) []

-- VIEW

renderPanel : String -> List (String, String) -> Html
renderPanel title pairs =
  let
    dlPair (label, value) =
      [ dt [] [ text label ], dd [] [ text value ] ]
  in
    div [ class "col-md-6" ] [
      div [ class "panel panel-default" ] [
        div [ class "panel-heading" ] [ text title],
        div [ class "panel-body" ] [
          dl [ class "dl-horizontal" ] (List.foldr (++) [] (List.map dlPair pairs))
        ]
      ]
    ]

renderAlloc title rows =
  let
    row (type', block, carrier) =
      tr [] [
        td [] [ text type' ],
        td [] [ text block ],
        td [] [ text carrier ]
      ]
  in
    div [ class "col-md-12"] [
      div [ class "panel panel-default" ] [
        div [ class "panel-heading" ] [ text title],
        div [ class "panel-body" ] [
          table [ class "table table-striped" ] [
            thead [] [
              tr [] [
                th [] [ text "Type" ],
                th [] [ text "Block size" ],
                th [] [ text "Carrier size" ]
              ]
            ],
            tbody [] (List.map row rows)
          ]
        ]
      ]
    ]

render : SystemRecord -> Html
render model =
  let
    (system, memory, cpus, statistics) = model.panels
    systemPanel = List.map2 (,) systemLabels system
    memoryPanel = List.map2 (,) memoryLabels memory
    cpusPanel = List.map2 (,) cpusLabels cpus
    statisticsPanel = List.map2 (,) statisticsLabels statistics
  in
    div [ class "container" ] [
      div [ class "row" ] [
        renderPanel "System and Architecture" systemPanel,
        renderPanel "Memory Usage" memoryPanel
      ],
      div [ class "row" ] [
        renderPanel "CPUs and Threads" cpusPanel,
        renderPanel "Statistics" statisticsPanel
      ],
      div [ class "row" ] [
        renderAlloc "Allocators" model.alloc
      ]
    ]

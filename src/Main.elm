module Main exposing (..)

import Browser
import Html exposing (Html, button, div, option, select, text)
import Html.Attributes exposing (disabled, id)


type alias Meeting =
    { durationInSeconds : Int
    }


type alias Model =
    Meeting


type Msg
    = Tick


initialModel : Model
initialModel =
    emptyMeeting


emptyMeeting : Meeting
emptyMeeting =
    Meeting 0


update : Msg -> Meeting -> Meeting
update msg meeting =
    meeting


view : Model -> Html msg
view model =
    div []
        [ title
        , startButton
        ]


title : Html msg
title =
    div [ id "title" ] [ text "Meeting price counter" ]


startButton : Html msg
startButton =
    button [ id "startButton" ] [ text "Start counting" ]


main =
    Browser.sandbox { init = emptyMeeting, update = update, view = view }

module Main exposing (..)

import Browser
import Html exposing (Html, button, div, option, select, text)
import Html.Attributes exposing (disabled, id)
import Html.Events exposing (onClick)


type alias Meeting =
    { amountSpent : Int
    , timerStatus : TimerStatus
    }


type alias Model =
    Meeting


type Msg
    = StartCounting


type TimerStatus
    = Stoped


initialModel : Model
initialModel =
    emptyMeeting


emptyMeeting : Meeting
emptyMeeting =
    Meeting 0 Stoped


update : Msg -> Meeting -> Meeting
update msg meeting =
    meeting


view : Model -> Html Msg
view model =
    div []
        [ title
        , startButton
        ]


title : Html Msg
title =
    div [ id "title" ] [ text "Meeting price counter" ]


startButton : Html Msg
startButton =
    button
        [ id "startButton"
        , onClick StartCounting
        ]
        [ text "Start counting" ]


main =
    Browser.sandbox { init = emptyMeeting, update = update, view = view }

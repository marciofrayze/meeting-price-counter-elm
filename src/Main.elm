module Main exposing (..)

import Browser
import Html exposing (Html, button, div, option, select, span, text)
import Html.Attributes exposing (disabled, id)
import Html.Events exposing (onClick)
import Time
import TimeHelper exposing (..)



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Meeting =
    { amountSpent : Int
    , timeElapsed : Time.Posix
    , timerStatus : TimerStatus
    }


type alias Model =
    Meeting


init : () -> ( Model, Cmd Msg )
init _ =
    ( emptyMeeting
    , Cmd.none
    )


type Msg
    = StartCounting
    | Tick Time.Posix


type TimerStatus
    = Stoped
    | Started


initialModel : Model
initialModel =
    emptyMeeting


emptyMeeting : Meeting
emptyMeeting =
    Meeting 0 (Time.millisToPosix 0) Stoped



-- UPDATE


update : Msg -> Meeting -> ( Meeting, Cmd Msg )
update msg meeting =
    let
        updatedMeeting =
            case msg of
                StartCounting ->
                    { meeting | timerStatus = Started }

                Tick _ ->
                    if meeting.timerStatus == Started then
                        { meeting | timeElapsed = addOneSecond meeting.timeElapsed }

                    else
                        meeting
    in
    ( updatedMeeting, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view meeting =
    div []
        [ title
        , startButton
        , timeElapsed meeting
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


timeElapsed : Meeting -> Html Msg
timeElapsed meeting =
    div []
        [ span [ id "timeElapsedTitle" ]
            [ text "Time elapsed: "
            ]
        , span
            [ id "timeElapsed" ]
            [ text (TimeHelper.formatTime meeting.timeElapsed)
            ]
        ]

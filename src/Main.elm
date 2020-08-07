module Main exposing (..)

import Browser
import Html exposing (Html, button, div, option, select, span, text)
import Html.Attributes exposing (disabled, id)
import Html.Events exposing (onClick)
import Time exposing (toSecond, utc)
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
    | PauseCounting
    | ResetCounting
    | Tick Time.Posix


type TimerStatus
    = Paused
    | Started


initialModel : Model
initialModel =
    emptyMeeting


emptyMeeting : Meeting
emptyMeeting =
    Meeting 0 (Time.millisToPosix 0) Paused



-- UPDATE


update : Msg -> Meeting -> ( Meeting, Cmd Msg )
update msg meeting =
    let
        updatedMeeting =
            case msg of
                StartCounting ->
                    { meeting | timerStatus = Started }

                PauseCounting ->
                    { meeting | timerStatus = Paused }

                ResetCounting ->
                    let
                        timeElapsedInSecods =
                            Time.toSecond Time.utc meeting.timeElapsed
                    in
                    if timeElapsedInSecods > 0 then
                        { meeting | timeElapsed = zeroSecondsInPosix }

                    else
                        meeting

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
        [ titleDiv
        , startButtonDiv meeting
        , pauseButtonDiv meeting
        , resetButtonDiv meeting
        , timeElapsedDiv meeting
        , amountSpentDiv
        ]


titleDiv : Html Msg
titleDiv =
    div [ id "title" ] [ text "Meeting price counter" ]


startButtonDiv : Meeting -> Html Msg
startButtonDiv meeting =
    let
        isDisabled =
            meeting.timerStatus /= Paused
    in
    button
        [ id "startButton"
        , onClick StartCounting
        , disabled isDisabled
        ]
        [ text "Start counting" ]


pauseButtonDiv : Meeting -> Html Msg
pauseButtonDiv meeting =
    let
        isDisabled =
            meeting.timerStatus == Paused
    in
    button
        [ id "pauseButton"
        , onClick PauseCounting
        , disabled isDisabled
        ]
        [ text "Pause" ]


resetButtonDiv : Meeting -> Html Msg
resetButtonDiv meeting =
    let
        isDisabled =
            (timeElapsedInSeconds meeting.timeElapsed == 0)
                || (meeting.timerStatus /= Paused)
    in
    button
        [ id "resetButton"
        , onClick ResetCounting
        , disabled isDisabled
        ]
        [ text "Reset" ]


timeElapsedDiv : Meeting -> Html Msg
timeElapsedDiv meeting =
    div []
        [ span [ id "timeElapsedTitle" ]
            [ text "Time elapsed: "
            ]
        , span
            [ id "timeElapsed" ]
            [ text (TimeHelper.formatTime meeting.timeElapsed)
            ]
        ]


amountSpentDiv : Html Msg
amountSpentDiv =
    div []
        [ span [ id "amountSpentTitle" ]
            [ text "Amount spent: "
            ]
        , span
            [ id "amountSpent" ]
            [ text "0"
            ]
        ]

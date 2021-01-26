module Main exposing (..)

import AmountSpentFormatter exposing (formatAmountSpent)
import Browser
import Css exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, id, value)
import Html.Styled.Events exposing (on, onClick)
import Json.Decode exposing (Decoder, at, string)
import Time exposing (toSecond, utc)
import TimeFormatter exposing (addOneSecond, formatTime, zeroSecondsInPosix)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view >> toUnstyled
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Salary =
    Float


type alias Meeting =
    { amountSpent : Float
    , timeElapsed : Time.Posix
    , timerStatus : TimerStatus
    , averageSalaryPerMonthPerAtendee : Salary
    , numberOfAtendees : Int
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
    | AverageSalarySelected String
    | NumberOfAtendeesSelected String
    | Tick Time.Posix


type TimerStatus
    = Paused
    | Started


initialModel : Model
initialModel =
    emptyMeeting


emptyMeeting : Meeting
emptyMeeting =
    Meeting 0 (Time.millisToPosix 0) Paused 0 0



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
                        { meeting
                            | timeElapsed = zeroSecondsInPosix
                            , amountSpent = 0
                        }

                    else
                        meeting

                Tick _ ->
                    if meeting.timerStatus == Started then
                        let
                            amountSpendInThisElapsedSecond =
                                meeting.averageSalaryPerMonthPerAtendee / 60 / 60 / 20

                            numberOfAtendessAsFloat =
                                toFloat meeting.numberOfAtendees
                        in
                        { meeting
                            | timeElapsed = addOneSecond meeting.timeElapsed
                            , amountSpent = meeting.amountSpent + (amountSpendInThisElapsedSecond * numberOfAtendessAsFloat)
                        }

                    else
                        meeting

                AverageSalarySelected selectedAverageSalary ->
                    { meeting
                        | averageSalaryPerMonthPerAtendee =
                            String.toFloat selectedAverageSalary
                                |> Maybe.withDefault 0
                    }

                NumberOfAtendeesSelected selectedNumberOfAtendees ->
                    { meeting
                        | numberOfAtendees =
                            String.toInt selectedNumberOfAtendees
                                |> Maybe.withDefault 1
                    }
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
        , numberOfAtendeesDiv
        , averageSalaryDiv
        , startButtonDiv meeting
        , pauseButtonDiv meeting
        , resetButtonDiv meeting
        , timeElapsedDiv meeting
        , amountSpentDiv meeting
        , averageSalarySelected meeting
        , numberOfAtendeesSelected meeting
        ]


averageSalarySelected : Meeting -> Html Msg
averageSalarySelected meeting =
    div []
        [ text "Number of average salary selected:"
        , text (String.fromFloat meeting.averageSalaryPerMonthPerAtendee)
        ]


numberOfAtendeesSelected : Meeting -> Html Msg
numberOfAtendeesSelected meeting =
    div []
        [ text "Number of atendees selected:"
        , text (String.fromInt meeting.numberOfAtendees)
        ]


titleDiv : Html Msg
titleDiv =
    let
        titleCss =
            css
                [ display inlineBlock
                , padding (px 20)

                --                , border3 (px 5) solid (rgb 120 120 120)
                ]
    in
    div
        [ id "title"
        , titleCss
        ]
        [ text "Meeting price counter" ]


averageSalaryDiv : Html Msg
averageSalaryDiv =
    let
        targetSelectedValue : Decoder String
        targetSelectedValue =
            at [ "target", "value" ] string

        onSelect : (String -> msg) -> Html.Styled.Attribute msg
        onSelect msg =
            on "change" (Json.Decode.map msg targetSelectedValue)
    in
    div [ id "averageSalary" ]
        [ text "Whats is the average salary per month per participant?"
        , select [ Html.Styled.Attributes.disabled False, id "averageSalarySelect", onSelect AverageSalarySelected ]
            (List.map
                (\amount ->
                    option [ value amount ]
                        [ text
                            ("$" ++ amount ++ " dollars")
                        ]
                )
                [ "0", "300", "500", "1000", "2000", "4000", "6000", "8000", "1000", "13000", "18000", "22000", "30000" ]
            )
        ]


numberOfAtendeesDiv : Html Msg
numberOfAtendeesDiv =
    let
        targetSelectedValue : Decoder String
        targetSelectedValue =
            at [ "target", "value" ] string

        onSelect : (String -> msg) -> Html.Styled.Attribute msg
        onSelect msg =
            on "change" (Json.Decode.map msg targetSelectedValue)

        listOfNumberOfAtendees =
            List.map (\numberOfAtendees -> String.fromInt numberOfAtendees) (List.range 0 100)
    in
    div [ id "numberOfAtendees" ]
        [ text "Number of atendess:"
        , select [ Html.Styled.Attributes.disabled False, id "numberOfAtendeesSelect", onSelect NumberOfAtendeesSelected ]
            (List.map
                (\amount ->
                    option [ value amount ]
                        [ text amount
                        ]
                )
                listOfNumberOfAtendees
            )
        ]


startButtonDiv : Meeting -> Html Msg
startButtonDiv meeting =
    let
        isDisabled =
            meeting.timerStatus /= Paused
    in
    button
        [ id "startButton"
        , onClick StartCounting
        , Html.Styled.Attributes.disabled isDisabled
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
        , Html.Styled.Attributes.disabled isDisabled
        ]
        [ text "Pause" ]


resetButtonDiv : Meeting -> Html Msg
resetButtonDiv meeting =
    let
        isDisabled =
            (meeting.timeElapsed == zeroSecondsInPosix)
                || (meeting.timerStatus /= Paused)
    in
    button
        [ id "resetButton"
        , onClick ResetCounting
        , Html.Styled.Attributes.disabled isDisabled
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
            [ text (TimeFormatter.formatTime meeting.timeElapsed)
            ]
        ]


amountSpentDiv : Meeting -> Html Msg
amountSpentDiv meeting =
    div []
        [ span [ id "amountSpentTitle" ]
            [ text "Amount spent: "
            ]
        , span
            [ id "amountSpent" ]
            [ formatAmountSpent meeting.amountSpent
                |> text
            ]
        ]

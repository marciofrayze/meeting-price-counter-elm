module Main exposing (..)

import AmountSpentFormatter exposing (formatAmountSpent)
import Browser
import Css exposing (..)
import Css.ModernNormalize as ModernNormalize
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, id, value)
import Html.Styled.Events exposing (on, onClick)
import Json.Decode exposing (Decoder, at, string)
import Time
import TimeFormatter exposing (addOneSecond, zeroSecondsInPosix)



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


selectContainerCss : Attribute msg
selectContainerCss =
    css
        [ display inlineFlex
        , fontSize (px 34)
        ]


selectDescriptionCss : Attribute msg
selectDescriptionCss =
    css
        [ minWidth (Css.em 10)
        , margin4 (px 0) (px 0) (Css.em 1.2) (px 0)
        ]


selectCss : Attribute msg
selectCss =
    css
        [ height (Css.em 2.5)
        , minWidth (Css.em 10)
        , minHeight (Css.em 1)
        , fontSize (px 34)
        , backgroundColor (rgb 255 255 255)
        ]


view : Model -> Html Msg
view meeting =
    let
        borderCss =
            css
                [ border3 (px 5) solid (rgb 120 120 120)
                , padding (px 20)
                , margin4 (px 40) (px 40) (px 0) (px 40)
                ]
    in
    div
        []
        [ ModernNormalize.globalStyledHtml
        , div
            [ borderCss ]
            [ titleDiv
            , meetingInformationsFormDiv
            , amountSpentDiv meeting
            , timeElapsedDiv meeting
            , buttonsControlsDiv meeting
            ]
        , footerDiv
        ]


titleDiv : Html Msg
titleDiv =
    let
        headerCss =
            css
                [ textAlign center
                , padding4 (px 0) (px 0) (Css.em 3) (px 0)
                ]

        mainTitleCss =
            css
                [ fontSize (px 80)
                ]

        subTitleCss =
            css
                [ display inlineBlock
                , fontSize (px 80)
                , margin2 (px 0) (px 30)
                ]
    in
    div
        [ headerCss
        , id "header"
        ]
        [ span [ mainTitleCss, id "title" ]
            [ text "Meeting"
            , br [] []
            , text "PRICE"
            , span [ subTitleCss ]
                [ text "counter" ]
            ]
        ]


meetingInformationsFormDiv : Html Msg
meetingInformationsFormDiv =
    let
        meetingInformationFormCss =
            css []
    in
    div
        [ id "meetingInformationForm", meetingInformationFormCss ]
        [ numberOfAtendeesDiv
        , br [] []
        , averageSalaryDiv
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
    div
        [ id "numberOfAtendees"
        , selectContainerCss
        ]
        [ div [ selectDescriptionCss ]
            [ text "NUMBER OF"
            , br [] []
            , text "ATTENDEES"
            ]
        , div
            []
            [ select [ selectCss, Html.Styled.Attributes.disabled False, id "numberOfAtendeesSelect", onSelect NumberOfAtendeesSelected ]
                (List.map
                    (\amount ->
                        option [ value amount ]
                            [ text amount
                            ]
                    )
                    listOfNumberOfAtendees
                )
            ]
        ]


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
    div
        [ id "averageSalary"
        , selectContainerCss
        ]
        [ div [ selectDescriptionCss ]
            [ text
                "AVERAGE"
            , br [] []
            , text "MONTHLY"
            , br [] []
            , text "SALARY"
            ]
        , div []
            [ select [ selectCss, Html.Styled.Attributes.disabled False, id "averageSalarySelect", onSelect AverageSalarySelected ]
                (List.map
                    (\amount ->
                        option [ value amount ]
                            [ text
                                ("$" ++ formatAmountSpent (Maybe.withDefault 0 (String.toFloat amount)) ++ " dollars")
                            ]
                    )
                    [ "0", "300", "500", "1000", "2000", "4000", "6000", "8000", "10000", "13000", "18000", "22000", "30000" ]
                )
            ]
        ]


buttonsControlsDiv : Meeting -> Html Msg
buttonsControlsDiv meeting =
    let
        buttonsControlsCss =
            css
                [ textAlign center
                , marginTop (px 30)
                ]
    in
    div [ buttonsControlsCss ]
        [ startButtonDiv meeting
        , pauseButtonDiv meeting
        , resetButtonDiv meeting
        ]


bigButtonCss : Attribute msg
bigButtonCss =
    css
        [ margin (px 10)
        , minHeight (Css.em 5.5)
        ]


bigButtonLabel : String -> Html msg
bigButtonLabel label =
    let
        bigButtonLabelCss =
            css
                [ fontSize (px 50) ]
    in
    span [ bigButtonLabelCss ] [ text label ]


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
        , bigButtonCss
        ]
        [ bigButtonLabel "Start" ]


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
        , bigButtonCss
        ]
        [ bigButtonLabel "Pause" ]


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
        , bigButtonCss
        ]
        [ bigButtonLabel "Reset" ]


timeElapsedDiv : Meeting -> Html Msg
timeElapsedDiv meeting =
    let
        timerCss =
            css
                [ fontSize (px 43)
                , textAlign center
                ]
    in
    div [ id "timeElapsed", timerCss ]
        [ text (TimeFormatter.formatTime meeting.timeElapsed)
        ]


amountSpentDiv : Meeting -> Html Msg
amountSpentDiv meeting =
    let
        amountSpentContainerCss =
            css
                [ fontSize (px 100)
                , textAlign center
                , margin (px 20)
                ]

        amountSpentCss =
            css
                [ border3 (px 3) solid (rgb 120 120 120)
                , padding (px 10)
                , margin (px 20)
                ]
    in
    div
        [ id "amountSpent"
        , amountSpentContainerCss
        ]
        [ text "$"
        , span [ amountSpentCss ]
            [ formatAmountSpent meeting.amountSpent
                |> text
            ]
        ]


footerDiv : Html Msg
footerDiv =
    let
        footerCss =
            css
                [ fontSize (px 15)
                , margin4 (px 10) (px 10) (px 20) (px 40)
                ]
    in
    div
        [ id "footer"
        , footerCss
        ]
        [ text "Don't take this website too seriously."
        ]

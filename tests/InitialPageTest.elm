module InitialPageTest exposing (..)

import Expect
import Html.Styled exposing (toUnstyled)
import Main exposing (Msg(..), TimerStatus(..), emptyMeeting, view)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector


suite : Test
suite =
    let
        emptyMeetingHtml =
            view emptyMeeting
                |> toUnstyled
                |> Query.fromHtml
    in
    describe "On initial page"
        [ describe "user should see"
            [ test "a title" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.find [ Selector.id "title" ]
                        |> Query.has
                            [ Selector.text "Meeting"
                            , Selector.text "PRICE"
                            , Selector.text "counter"
                            ]
            , test "an enabled 'Start' button" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.has
                            [ Selector.id "pauseButton"
                            , Selector.disabled True
                            , Selector.text "Start"
                            ]
            , test "a disabled 'Pause' button" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.has
                            [ Selector.id "pauseButton"
                            , Selector.disabled False
                            , Selector.text "Pause"
                            ]
            , test "a disabled 'Reset' button" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.has
                            [ Selector.id "resetButton"
                            , Selector.disabled True
                            , Selector.text "Reset"
                            ]
            , test "the time elapsed as 0" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.find [ Selector.id "timeElapsed" ]
                        |> Query.has [ Selector.text "0" ]
            , test "the amount spent as 0" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.find [ Selector.id "amountSpent" ]
                        |> Query.has [ Selector.text "0" ]
            , test "a title for the average salary selector" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.find [ Selector.id "averageSalary" ]
                        |> Query.has [ Selector.text "AVERAGE" ]
            , test "an average salary select" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.find [ Selector.id "averageSalarySelect", Selector.disabled False ]
                        |> Query.has
                            (List.map
                                (\amount ->
                                    Selector.text
                                        ("$" ++ amount ++ " dollars")
                                )
                                [ "0.00", "300.00", "500.00", "1,000.00", "2,000.00", "4,000.00", "6,000.00", "8,000.00", "1,000.00", "13,000.00" ]
                            )
            , test "a number of atendees select" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.find [ Selector.id "numberOfAtendeesSelect", Selector.disabled False ]
                        |> Query.has
                            (List.map
                                (\numberOfAtendees ->
                                    Selector.text
                                        (String.fromInt numberOfAtendees)
                                )
                                (List.range 1 100)
                            )
            ]
        , describe "in the initial model"
            [ test "average salary per month should be 0" <|
                \_ ->
                    Expect.equal emptyMeeting.averageSalaryPerMonthPerAtendee 0
            , test "amount spent in the meeting should be 0" <|
                \_ ->
                    Expect.equal emptyMeeting.amountSpent 0
            , test "timer shoud be Paused" <|
                \_ ->
                    Expect.equal emptyMeeting.timerStatus Paused
            ]
        , describe "user actions"
            [ describe "when clicking 'Start'"
                [ test "should dispatch StartCounting" <|
                    \_ ->
                        emptyMeetingHtml
                            |> Query.find [ Selector.id "startButton" ]
                            |> Event.simulate Event.click
                            |> Event.expect StartCounting
                ]
            ]
        ]

module InitialPageTest exposing (..)

import Expect exposing (Expectation)
import Main exposing (Msg(..), TimerStatus(..), emptyMeeting, view)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TimeHelper exposing (..)


suite : Test
suite =
    let
        emptyMeetingHtml =
            view emptyMeeting
                |> Query.fromHtml
    in
    describe "User opens initial page"
        [ test "should see a title" <|
            \_ ->
                emptyMeetingHtml
                    |> Query.find [ Selector.id "title" ]
                    |> Query.has [ Selector.text "Meeting price counter" ]
        , test "should see an enabled 'Start counting' button" <|
            \_ ->
                emptyMeetingHtml
                    |> Query.has
                        [ Selector.id "pauseButton"
                        , Selector.disabled True
                        , Selector.text "Start counting"
                        ]
        , test "should see a disabled 'Pause' button" <|
            \_ ->
                emptyMeetingHtml
                    |> Query.has
                        [ Selector.id "pauseButton"
                        , Selector.disabled False
                        , Selector.text "Pause"
                        ]
        , test "should see a disabled 'Reset' button" <|
            \_ ->
                emptyMeetingHtml
                    |> Query.has
                        [ Selector.id "resetButton"
                        , Selector.disabled True
                        , Selector.text "Reset"
                        ]
        , test "should see the time elapsed as 0" <|
            \_ ->
                emptyMeetingHtml
                    |> Query.find [ Selector.id "timeElapsed" ]
                    |> Query.has [ Selector.text "0" ]
        , test "should see the amount spent as 0" <|
            \_ ->
                emptyMeetingHtml
                    |> Query.find [ Selector.id "amountSpent" ]
                    |> Query.has [ Selector.text "0" ]
        , test "should see a title for the selector" <|
            \_ ->
                emptyMeetingHtml
                    |> Query.find [ Selector.id "averageSalary" ]
                    |> Query.has [ Selector.text "Whats is the average salary per month per participant?" ]
        , test "should see an average salary select" <|
            \_ ->
                emptyMeetingHtml
                    |> Query.find [ Selector.id "averageSalarySelect", Selector.disabled False ]
                    |> Query.has
                        (List.map
                            (\value ->
                                Selector.text
                                    ("$" ++ value ++ " dollars")
                            )
                            [ "0", "300", "500", "1000", "2000", "4000", "6000", "8000", "1000", "13000" ]
                        )
        , test "average salary per month per atendee should be 0" <|
            \_ ->
                Expect.equal emptyMeeting.averageSalaryPerMonthPerAtendee 0
        , test "amount spent in the meeting should be 0" <|
            \_ ->
                Expect.equal emptyMeeting.amountSpent 0
        , test "timer shoud be Paused" <|
            \_ ->
                Expect.equal emptyMeeting.timerStatus Paused
        , describe "when clicking 'Start counting'"
            [ test "should dispatch StartCounting" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.find [ Selector.id "startButton" ]
                        |> Event.simulate Event.click
                        |> Event.expect StartCounting
            ]
        , describe "when selecting an average 'Start counting'"
            [ test "should dispatch StartCounting" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.find [ Selector.id "startButton" ]
                        |> Event.simulate Event.click
                        |> Event.expect StartCounting
            ]

        -- TODO: Don't know how to simulate this, yet
        -- , describe "when selecting last average salary"
        --     [ test "should dispatch AverageSalarySelected with 30000 value" <|
        --         \_ ->
        --             emptyMeetingHtml
        --                 |> Query.find [ Selector.id "averageSalarySelect" ]
        --                 |> Event.simulate Event.click
        --                 |> Event.expect AverageSalarySelected 30000
        --     ]
        ]

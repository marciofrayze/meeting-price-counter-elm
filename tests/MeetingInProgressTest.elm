module MeetingInProgressTest exposing (..)

import Expect exposing (Expectation, FloatingPointTolerance(..))
import Main exposing (Msg(..), TimerStatus(..), emptyMeeting, update, view)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TimeHelper exposing (..)


suite : Test
suite =
    let
        startedMeetingWithOneSecondElapsed =
            { emptyMeeting
                | timerStatus = Started
                , timeElapsed = TimeHelper.oneSecondInPosix
            }

        startedMeetingWithNoTimeElapsed =
            { emptyMeeting | timerStatus = Started }

        startedMeetingWithNoTimeElapsedHtml =
            view startedMeetingWithNoTimeElapsed
                |> Query.fromHtml

        startedMeetingWithOneSecondElapsedHtml =
            view startedMeetingWithNoTimeElapsed
                |> Query.fromHtml
    in
    describe "User is in a in progress meeting"
        [ test "should see a disabled 'Reset' button" <|
            \_ ->
                startedMeetingWithOneSecondElapsedHtml
                    |> Query.has
                        [ Selector.id "resetButton"
                        , Selector.disabled True
                        , Selector.text "Reset"
                        ]
        , test "should increment 1 second when a second is elapsed" <|
            \_ ->
                let
                    ( updatedMeeting, _ ) =
                        update (Tick oneSecondInPosix) startedMeetingWithNoTimeElapsed
                in
                Expect.equal updatedMeeting.timeElapsed oneSecondInPosix
        , test "should increment the current amount spent when a second is elapsed" <|
            \_ ->
                let
                    startedMeetingWithHighAverageSalary =
                        { startedMeetingWithNoTimeElapsed | averageSalaryPerMonthPerAtendee = 30000 }

                    ( updatedMeeting, _ ) =
                        update (Tick oneSecondInPosix) startedMeetingWithHighAverageSalary
                in
                Expect.within (Absolute 0.000001) updatedMeeting.amountSpent 0.416666667
        , test "should see a disabled 'Star counting' button" <|
            \_ ->
                startedMeetingWithNoTimeElapsedHtml
                    |> Query.find [ Selector.id "startButton" ]
                    |> Query.has [ Selector.disabled True ]
        , test "should see an enabled 'Pause' button" <|
            \_ ->
                startedMeetingWithNoTimeElapsedHtml
                    |> Query.find [ Selector.id "pauseButton" ]
                    |> Query.has [ Selector.disabled False ]
        , describe
            "When clicking 'Pause'"
            [ test "should dispatch PauseCounting" <|
                \_ ->
                    startedMeetingWithNoTimeElapsedHtml
                        |> Query.find [ Selector.id "pauseButton" ]
                        |> Event.simulate Event.click
                        |> Event.expect PauseCounting
            ]
        ]

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
            view startedMeetingWithOneSecondElapsed
                |> Query.fromHtml
    in
    describe "In a on progress meeting"
        [ describe "user should see"
            [ test "a disabled 'Reset' button" <|
                \_ ->
                    startedMeetingWithOneSecondElapsedHtml
                        |> Query.has
                            [ Selector.id "resetButton"
                            , Selector.disabled True
                            , Selector.text "Reset"
                            ]
            , test "a disabled 'Star counting' button" <|
                \_ ->
                    startedMeetingWithNoTimeElapsedHtml
                        |> Query.find [ Selector.id "startButton" ]
                        |> Query.has [ Selector.disabled True ]
            , test "an enabled 'Pause' button" <|
                \_ ->
                    startedMeetingWithNoTimeElapsedHtml
                        |> Query.find [ Selector.id "pauseButton" ]
                        |> Query.has [ Selector.disabled False ]
            , describe "actions should result in"
                [ test "increment of 1 second when a second is elapsed" <|
                    \_ ->
                        let
                            ( updatedMeeting, _ ) =
                                update (Tick oneSecondInPosix) startedMeetingWithNoTimeElapsed
                        in
                        Expect.equal updatedMeeting.timeElapsed oneSecondInPosix
                , test "increment the current amount spent when a second is elapsed" <|
                    \_ ->
                        let
                            startedMeetingWithHighAverageSalary =
                                { startedMeetingWithNoTimeElapsed | averageSalaryPerMonthPerAtendee = 30000 }

                            ( updatedMeeting, _ ) =
                                update (Tick oneSecondInPosix) startedMeetingWithHighAverageSalary
                        in
                        Expect.within (Absolute 0.000001) updatedMeeting.amountSpent 0.416666667
                , test "dispatch PauseCounting when clicking 'Pause' button" <|
                    \_ ->
                        startedMeetingWithNoTimeElapsedHtml
                            |> Query.find [ Selector.id "pauseButton" ]
                            |> Event.simulate Event.click
                            |> Event.expect PauseCounting
                ]
            ]
        ]

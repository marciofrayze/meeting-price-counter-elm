module MeetingInProgressTest exposing (..)

import Expect exposing (Expectation, FloatingPointTolerance(..))
import Html.Styled exposing (toUnstyled)
import Main exposing (Msg(..), TimerStatus(..), emptyMeeting, update, view)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TimeFormatter exposing (..)


suite : Test
suite =
    let
        startedMeetingWithOneSecondElapsed =
            { emptyMeeting
                | timerStatus = Started
                , timeElapsed = oneSecondInPosix
            }

        startedMeetingWithNoTimeElapsed =
            { emptyMeeting | timerStatus = Started }

        startedMeetingWithHighAverageSalaryOnePerson =
            { startedMeetingWithOneSecondElapsed
                | averageSalaryPerMonthPerAtendee = 30000
                , numberOfAtendees = 1
            }

        startedMeetingWithNoTimeElapsedHtml =
            view startedMeetingWithNoTimeElapsed
                |> toUnstyled
                |> Query.fromHtml

        startedMeetingWithOneSecondElapsedHtml =
            view startedMeetingWithOneSecondElapsed
                |> toUnstyled
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
            , test "an amount spent" <|
                \_ ->
                    startedMeetingWithNoTimeElapsedHtml
                        |> Query.find [ Selector.id "amountSpent" ]
                        |> Query.has [ Selector.text "0" ]
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
                            ( updatedMeeting, _ ) =
                                update (Tick oneSecondInPosix) startedMeetingWithHighAverageSalaryOnePerson
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

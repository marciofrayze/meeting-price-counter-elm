module MeetingInProgressTest exposing (..)

import Expect exposing (Expectation)
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
            { emptyMeeting | timerStatus = Started }

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
                        update (Tick oneSecondInPosix) startedMeetingWithOneSecondElapsed
                in
                Expect.equal updatedMeeting.timeElapsed oneSecondInPosix
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

module MeetingPausedTest exposing (..)

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
        pausedMeeting =
            { emptyMeeting | timerStatus = Paused }

        pausedMeetingHtml =
            view pausedMeeting
                |> Query.fromHtml

        pausedMeetingWithTimeElapsed =
            { pausedMeeting
                | timeElapsed = oneSecondInPosix
            }

        pausedMeetingWithTimeElapsedHtml =
            view pausedMeetingWithTimeElapsed
                |> Query.fromHtml
    in
    describe "User is in a Paused meeting"
        [ test "should see an enabled 'Start counting' button" <|
            \_ ->
                pausedMeetingHtml
                    |> Query.find [ Selector.id "startButton" ]
                    |> Query.has [ Selector.disabled False ]
        , describe "when time elapsed is zero seconds"
            [ test "should see an disabled 'Reset' button" <|
                \_ ->
                    pausedMeetingHtml
                        |> Query.find [ Selector.id "resetButton" ]
                        |> Query.has [ Selector.disabled True ]
            ]
        , describe "when time elapsed is greater than zero seconds"
            [ test "should see an enabled 'Reset' button" <|
                \_ ->
                    pausedMeetingWithTimeElapsedHtml
                        |> Query.find [ Selector.id "resetButton" ]
                        |> Query.has [ Selector.disabled False ]
            ]
        , describe "when one second elapses"
            [ test "should keep the same amount of time elapsed" <|
                \_ ->
                    let
                        ( updatedMeeting, _ ) =
                            update (Tick oneSecondInPosix) pausedMeeting
                    in
                    Expect.equal updatedMeeting.timeElapsed zeroSecondsInPosix
            ]
        , describe "when clicking 'Reset'"
            [ test "should dispatch ResetMeeting" <|
                \_ ->
                    pausedMeetingWithTimeElapsedHtml
                        |> Query.find [ Selector.id "resetButton" ]
                        |> Event.simulate Event.click
                        |> Event.expect ResetCounting
            ]
        , describe "when ResetCouting is received"
            [ test "should set time elapsed to 0" <|
                \_ ->
                    let
                        ( updatedMeeting, _ ) =
                            update ResetCounting pausedMeetingWithTimeElapsed
                    in
                    Expect.equal updatedMeeting.timeElapsed zeroSecondsInPosix
            ]
        ]

module MeetingPausedTest exposing (..)

import Expect exposing (Expectation)
import Main exposing (Msg(..), TimerStatus(..), emptyMeeting, update, view)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TimeHelper exposing (oneSecondInPosix, zeroSecondsInPosix)


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

        pausedMeetingWithTimeElapsedAndSomeAmountSpent =
            { pausedMeeting
                | timeElapsed = oneSecondInPosix
                , amountSpent = 500
            }
    in
    describe "In a Paused meeting"
        [ describe "user should see"
            [ test "an enabled 'Start counting' button" <|
                \_ ->
                    pausedMeetingHtml
                        |> Query.find [ Selector.id "startButton" ]
                        |> Query.has [ Selector.disabled False ]
            , test "a disabled 'Pause' button" <|
                \_ ->
                    pausedMeetingHtml
                        |> Query.find [ Selector.id "pauseButton" ]
                        |> Query.has [ Selector.disabled True ]
            , test "a disabled 'Reset' button if time elapsed is zero seconds" <|
                \_ ->
                    pausedMeetingHtml
                        |> Query.find [ Selector.id "resetButton" ]
                        |> Query.has [ Selector.disabled True ]
            , test "an enabled 'Reset' button if time elapsed is greater than zero seconds" <|
                \_ ->
                    pausedMeetingWithTimeElapsedHtml
                        |> Query.find [ Selector.id "resetButton" ]
                        |> Query.has [ Selector.disabled False ]
            ]
        , describe "actions should result in"
            [ test "when 1 second elapses, should keep the same amount of time elapsed" <|
                \_ ->
                    let
                        ( updatedMeeting, _ ) =
                            update (Tick oneSecondInPosix) pausedMeeting
                    in
                    Expect.equal updatedMeeting.timeElapsed zeroSecondsInPosix
            , test "when clicking 'Reset' button, should dispatch ResetCounting" <|
                \_ ->
                    pausedMeetingWithTimeElapsedHtml
                        |> Query.find [ Selector.id "resetButton" ]
                        |> Event.simulate Event.click
                        |> Event.expect ResetCounting
            , describe "when a ResetCouting is received"
                [ test "should set time elapsed to 0" <|
                    \_ ->
                        let
                            ( updatedMeeting, _ ) =
                                update ResetCounting pausedMeetingWithTimeElapsed
                        in
                        Expect.equal updatedMeeting.timeElapsed zeroSecondsInPosix
                , test "should set amount spent to 0" <|
                    \_ ->
                        let
                            ( updatedMeeting, _ ) =
                                update ResetCounting pausedMeetingWithTimeElapsedAndSomeAmountSpent
                        in
                        Expect.equal updatedMeeting.amountSpent 0
                ]
            ]
        ]

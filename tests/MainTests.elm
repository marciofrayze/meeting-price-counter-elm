module MainTests exposing (..)

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
        emptyMeetingHtml =
            view emptyMeeting
                |> Query.fromHtml
    in
    describe "Meeting price counter"
        [ describe "When entering the site"
            [ test "should see a title" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.find [ Selector.id "title" ]
                        |> Query.has [ Selector.text "Meeting price counter" ]
            , test "should see an enabled 'Start counting button" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.has [ Selector.id "startButton", Selector.disabled False ]
            , test "should see the time elapsed as 0" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.find [ Selector.id "timeElapsed" ]
                        |> Query.has [ Selector.text "0" ]
            , test "amount spent in the meeting should be 0" <|
                \_ ->
                    Expect.equal emptyMeeting.amountSpent 0
            , test "timer shoud be Stoped" <|
                \_ ->
                    Expect.equal emptyMeeting.timerStatus Stoped
            ]
        , describe "When clicking Start counting"
            [ test "should dispatch StartCounting" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.find [ Selector.id "startButton" ]
                        |> Event.simulate Event.click
                        |> Event.expect StartCounting
            ]
        , describe "When one second elapses and meeting is Stoped"
            [ test "should keep the same amount of time elapsed" <|
                \_ ->
                    let
                        stopedMeeting =
                            emptyMeeting

                        ( updatedMeeting, _ ) =
                            update (Tick oneSecondInPosix) stopedMeeting
                    in
                    Expect.equal updatedMeeting.timeElapsed zeroSecondsInPosix
            ]
        , describe "When StartCounting is receive"
            [ test "should change meeting status to Started" <|
                \_ ->
                    let
                        ( updatedMeeting, _ ) =
                            update StartCounting emptyMeeting
                    in
                    Expect.equal updatedMeeting.timerStatus Started
            ]
        , describe "Meeting in progress"
            [ describe "When one second elapses and meeting is Started"
                [ test "should increment in 1 second in the meeting time elapsed" <|
                    \_ ->
                        let
                            startedMeeting =
                                { emptyMeeting | timerStatus = Started }

                            ( updatedMeeting, _ ) =
                                update (Tick oneSecondInPosix) startedMeeting
                        in
                        Expect.equal updatedMeeting.timeElapsed oneSecondInPosix
                ]
            ]
        ]

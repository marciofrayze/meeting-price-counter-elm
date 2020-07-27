module MainTests exposing (..)

import Expect exposing (Expectation)
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
                |> Query.fromHtml
    in
    describe "When entering the site"
        [ test "should see a title" <|
            \_ ->
                emptyMeetingHtml
                    |> Query.find [ Selector.id "title" ]
                    |> Query.has [ Selector.text "Meeting price counter" ]
        , test "should see a start counting button" <|
            \_ ->
                emptyMeetingHtml
                    |> Query.has [ Selector.id "startButton" ]
        , test "amount spent in the meeting should be 0" <|
            \_ ->
                Expect.equal emptyMeeting.amountSpent 0
        , test "timer shoud be Stoped" <|
            \_ ->
                Expect.equal emptyMeeting.timerStatus Stoped
        , describe "When clicking Start counting"
            [ test "Should dispatch start Counting" <|
                \_ ->
                    emptyMeetingHtml
                        |> Query.find [ Selector.id "startButton" ]
                        |> Event.simulate Event.click
                        |> Event.expect StartCounting
            ]
        ]

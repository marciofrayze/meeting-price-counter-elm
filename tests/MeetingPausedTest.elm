module MeetingPausedTest exposing (..)

import Expect exposing (Expectation)
import Main exposing (Msg(..), TimerStatus(..), emptyMeeting, update, view)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TimeHelper exposing (..)


suite : Test
suite =
    let
        pausedMetting =
            { emptyMeeting | timerStatus = Paused }

        pausedMeetingHtml =
            view pausedMetting
                |> Query.fromHtml
    in
    describe "User is in a Paused meeting"
        [ test "should see an enabled 'Star counting' button" <|
            \_ ->
                pausedMeetingHtml
                    |> Query.find [ Selector.id "startButton" ]
                    |> Query.has [ Selector.disabled False ]
        , test "should see an disabled 'Pause' button" <|
            \_ ->
                pausedMeetingHtml
                    |> Query.find [ Selector.id "pauseButton" ]
                    |> Query.has [ Selector.disabled True ]
        , describe "when one second elapses"
            [ test "should keep the same amount of time elapsed" <|
                \_ ->
                    let
                        ( updatedMeeting, _ ) =
                            update (Tick oneSecondInPosix) pausedMetting
                    in
                    Expect.equal updatedMeeting.timeElapsed zeroSecondsInPosix
            ]
        ]

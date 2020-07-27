module UiTests exposing (..)

import Main exposing (emptyMeeting, view)
import Test exposing (..)
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
        ]

module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Main exposing (emptyMeeting, view)

suite : Test
suite =
  describe "When entering the site"
  [ test "should see a title" <|
    \_ ->
      view emptyMeeting
      |> Query.fromHtml
      |> Query.find [ Selector.id "title" ]
      |> Query.has [ Selector.text "Meeting price counter" ]
      ]

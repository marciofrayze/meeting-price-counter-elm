module TimeFormatterTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Time
import TimeFormatter exposing (..)


suite : Test
suite =
    describe "Time Formatter"
        [ describe "formating to string"
            [ test "given 0 seconds should be equal to 00:00:00" <|
                \_ ->
                    formatTime (Time.millisToPosix 0)
                        |> Expect.equal "00:00:00"
            , test "given 1 seconds should be equal to 00:00:01" <|
                \_ ->
                    formatTime (Time.millisToPosix 1000)
                        |> Expect.equal "00:00:01"
            , test "given 61 seconds should be equal to 00:01:01" <|
                \_ ->
                    formatTime (Time.millisToPosix 61000)
                        |> Expect.equal "00:01:01"
            , test "given 3600 seconds should be equal to 01:00:00" <|
                \_ ->
                    formatTime (Time.millisToPosix 3600000)
                        |> Expect.equal "01:00:00"
            , test "given 3735 seconds should be equal to 01:02:15" <|
                \_ ->
                    formatTime (Time.millisToPosix 3735000)
                        |> Expect.equal "01:02:15"
            ]
        ]

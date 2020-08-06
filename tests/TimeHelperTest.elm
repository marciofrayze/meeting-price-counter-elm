module TimeHelperTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Time
import TimeHelper exposing (..)


suite : Test
suite =
    describe "Time Helpers"
        [ test "given one thousand milliseconds should be equal to 1" <|
            \_ ->
                timeElapsedInSeconds (Time.millisToPosix 1000)
                    |> Expect.equal 1
        , test "given 0 milliseconds should be equal to 0" <|
            \_ ->
                timeElapsedInSeconds (Time.millisToPosix 0)
                    |> Expect.equal 0
        ]

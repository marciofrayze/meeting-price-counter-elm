module AmountSpentFormatterTest exposing (..)

import AmountSpentFormatter exposing (..)
import Expect
import Test exposing (..)


suite : Test
suite =
    describe "Amount Spent Formatter"
        [ describe "formating to string"
            [ test "given 0.0 dollars should be equal to 0 dollars" <|
                \_ ->
                    formatAmountSpent 0.0
                        |> Expect.equal "0 dollars"
            , test "given 1.5 dollars should be equal to 1.50 dollars" <|
                \_ ->
                    formatAmountSpent 1.5
                        |> Expect.equal "1.5 dollars"
            ]
        ]

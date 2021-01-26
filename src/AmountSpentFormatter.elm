module AmountSpentFormatter exposing (..)


formatAmountSpent : Float -> String
formatAmountSpent amount =
    let
        roundToTwoDecimals value =
            toFloat (round (value * 100)) / 100
    in
    String.fromFloat (roundToTwoDecimals amount) ++ " dollars"

module AmountSpentFormatter exposing (..)


formatAmountSpent : Float -> String
formatAmountSpent amount =
    let
        roundToTwoDecimals value =
            toFloat (round (value * 100)) / 100

        amountInCents =
            roundToTwoDecimals amount
    in
    String.fromFloat amountInCents

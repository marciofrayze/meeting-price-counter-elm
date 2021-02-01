module AmountSpentFormatter exposing (..)


formatAmountSpent : Float -> String
formatAmountSpent amount =
    let
        amountInCents =
            round (amount * 100)
                |> toFloat
                |> String.fromFloat

        shouldIncludeDot index =
            index == 2

        shouldIncludeComma index =
            modBy 4 (index - 2) == 0

        separator index =
            if shouldIncludeDot index then
                "."

            else if shouldIncludeComma index then
                ","

            else
                ""
    in
    amountInCents
        |> String.padLeft 3 '0'
        |> String.foldr
            (\digit acc -> String.fromChar digit ++ separator (String.length acc) ++ acc)
            ""

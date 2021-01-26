module TimeFormatter exposing (..)

import Time exposing (toHour, toMinute, toSecond, utc)


zeroSecondsInPosix : Time.Posix
zeroSecondsInPosix =
    Time.millisToPosix 0


oneSecondInPosix : Time.Posix
oneSecondInPosix =
    Time.millisToPosix 1000


formatTime : Time.Posix -> String
formatTime time =
    let
        formatTimeDigit digit =
            String.fromInt digit
                |> String.pad 2 '0'
    in
    formatTimeDigit (toHour utc time) ++ ":" ++ formatTimeDigit (toMinute utc time) ++ ":" ++ formatTimeDigit (toSecond utc time)


addOneSecond : Time.Posix -> Time.Posix
addOneSecond time =
    Time.posixToMillis time
        + 1000
        |> Time.millisToPosix

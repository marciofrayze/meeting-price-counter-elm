module TimeHelper exposing (..)

import Time exposing (toSecond, utc)


zeroSecondsInPosix : Time.Posix
zeroSecondsInPosix =
    Time.millisToPosix 0


oneSecondInPosix : Time.Posix
oneSecondInPosix =
    Time.millisToPosix 1000


formatTime : Time.Posix -> String
formatTime time =
    time
        |> Time.toSecond Time.utc
        |> String.fromInt


addOneSecond : Time.Posix -> Time.Posix
addOneSecond time =
    Time.posixToMillis time
        + 1000
        |> Time.millisToPosix


timeElapsedInSeconds : Time.Posix -> Int
timeElapsedInSeconds timeElapsed =
    toSecond utc timeElapsed

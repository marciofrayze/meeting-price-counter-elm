module TimeHelper exposing (..)

import Time


zeroSecondsInPosix : Time.Posix
zeroSecondsInPosix =
    Time.millisToPosix 0


oneSecondInPosix : Time.Posix
oneSecondInPosix =
    Time.millisToPosix 1000


formatTime : Time.Posix -> String
formatTime time =
    time |> Time.toSecond Time.utc |> String.fromInt


addOneSecond : Time.Posix -> Time.Posix
addOneSecond time =
    Time.millisToPosix (Time.posixToMillis time + 1000)

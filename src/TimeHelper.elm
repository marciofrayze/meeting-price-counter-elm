module TimeHelper exposing (oneSecondInPosix)

import Time


oneSecondInPosix : Time.Posix
oneSecondInPosix =
    Time.millisToPosix 1000

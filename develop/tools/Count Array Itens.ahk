for key, value in DesiredDroids
    count++
MsgBox, % "We're looking for " . count . " droid" . ( count=1 ? "" : "s" ) . "."
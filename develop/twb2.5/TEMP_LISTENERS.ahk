        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingToggleClipFrame", UInt, 0x1589, oscTypeInt)
        OnMessage(0x1589, "_trackingToggleClipFrame")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingToggleWindowFX", UInt, 0x1590, oscTypeInt)
        OnMessage(0x1590, "_trackingToggleWindowFX")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingStepFramesTrack", UInt, 0x1591, oscTypeInt)
        OnMessage(0x1591, "_trackingStepFramesTrack")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingTrackReverse", UInt, 0x1592, oscTypeInt)
        OnMessage(0x1592, "_trackingTrackReverse")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingStopTracking", UInt, 0x1593, oscTypeInt)
        OnMessage(0x1593, "_trackingStopTracking")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingTrackForward", UInt, 0x1594, oscTypeInt)
        OnMessage(0x1594, "_trackingTrackForward")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingTrackReverseForward", UInt, 0x1595, oscTypeInt)
        OnMessage(0x1595, "_trackingTrackReverseForward")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingAddPoint", UInt, 0x1596, oscTypeInt)
        OnMessage(0x1596, "_trackingAddPoint")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingRemovePoint", UInt, 0x1597, oscTypeInt)
        OnMessage(0x1597, "_trackingRemovePoint")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingPreviousKeyframe", UInt, 0x1598, oscTypeInt)
        OnMessage(0x1598, "_trackingPreviousKeyframe")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingAddKeyframe", UInt, 0x1599, oscTypeInt)
        OnMessage(0x1599, "_trackingAddKeyframe")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingNextKeyframe", UInt, 0x1600, oscTypeInt)
        OnMessage(0x1600, "_trackingNextKeyframe")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingPan", UInt, 0x1601, oscTypeInt)
        OnMessage(0x1601, "_trackingPan")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingTilt", UInt, 0x1602, oscTypeInt)
        OnMessage(0x1602, "_trackingTilt")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingZoom", UInt, 0x1603, oscTypeInt)
        OnMessage(0x1603, "_trackingZoom")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingRotate", UInt, 0x1604, oscTypeInt)
        OnMessage(0x1604, "_trackingRotate")

        DllCall("OSC2AHK.dll\addListener", AStr, "/tracking3D", UInt, 0x1605, oscTypeInt)
        OnMessage(0x1605, "_tracking3D")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingShowTracking", UInt, 0x1606, oscTypeInt)
        OnMessage(0x1606, "_trackingShowTracking")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingCopyData", UInt, 0x1607, oscTypeInt)
        OnMessage(0x1607, "_trackingCopyData")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingPasteData", UInt, 0x1608, oscTypeInt)
        OnMessage(0x1608, "_trackingPasteData")

        DllCall("OSC2AHK.dll\addListener", AStr, "/trackingResetAll", UInt, 0x1609, oscTypeInt)
        OnMessage(0x1609, "_trackingResetAll")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingModeEdit", UInt, 0x1610, oscTypeInt)
        OnMessage(0x1610, "_sizingModeEdit")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingModeInput", UInt, 0x1611, oscTypeInt)
        OnMessage(0x1611, "_sizingModeInput")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingModeOutput", UInt, 0x1612, oscTypeInt)
        OnMessage(0x1612, "_sizingModeOutput")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingModeNode", UInt, 0x1613, oscTypeInt)
        OnMessage(0x1613, "_sizingModeNode")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingModeReference", UInt, 0x1614, oscTypeInt)
        OnMessage(0x1614, "_sizingModeReference")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingResetAll", UInt, 0x1615, oscTypeInt)
        OnMessage(0x1615, "_sizingResetAll")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditPan", UInt, 0x1616, oscTypeInt)
        OnMessage(0x1616, "_sizingEditPan")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditCropLeft", UInt, 0x1617, oscTypeInt)
        OnMessage(0x1617, "_sizingEditCropLeft")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditTilt", UInt, 0x1618, oscTypeInt)
        OnMessage(0x1618, "_sizingEditTilt")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditCropRight", UInt, 0x1619, oscTypeInt)
        OnMessage(0x1619, "_sizingEditCropRight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditRotate", UInt, 0x1620, oscTypeInt)
        OnMessage(0x1620, "_sizingEditRotate")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditCropTop", UInt, 0x1621, oscTypeInt)
        OnMessage(0x1621, "_sizingEditCropTop")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditDistortion", UInt, 0x1622, oscTypeInt)
        OnMessage(0x1622, "_sizingEditDistortion")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditCropBottom", UInt, 0x1623, oscTypeInt)
        OnMessage(0x1623, "_sizingEditCropBottom")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditFlip", UInt, 0x1624, oscTypeInt)
        OnMessage(0x1624, "_sizingEditFlip")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditZoomX", UInt, 0x1625, oscTypeInt)
        OnMessage(0x1625, "_sizingEditZoomX")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditSoftness", UInt, 0x1626, oscTypeInt)
        OnMessage(0x1626, "_sizingEditSoftness")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditZoomY", UInt, 0x1627, oscTypeInt)
        OnMessage(0x1627, "_sizingEditZoomY")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditPitch", UInt, 0x1628, oscTypeInt)
        OnMessage(0x1628, "_sizingEditPitch")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditYaw", UInt, 0x1629, oscTypeInt)
        OnMessage(0x1629, "_sizingEditYaw")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditLensCorrection", UInt, 0x1630, oscTypeInt)
        OnMessage(0x1630, "_sizingEditLensCorrection")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditResetSizing", UInt, 0x1631, oscTypeInt)
        OnMessage(0x1631, "_sizingEditResetSizing")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingEditResetCropBlanking", UInt, 0x1632, oscTypeInt)
        OnMessage(0x1632, "_sizingEditResetCropBlanking")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputPan", UInt, 0x1633, oscTypeInt)
        OnMessage(0x1633, "_sizingInputPan")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputBlankingTop", UInt, 0x1634, oscTypeInt)
        OnMessage(0x1634, "_sizingInputBlankingTop")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputTilt", UInt, 0x1635, oscTypeInt)
        OnMessage(0x1635, "_sizingInputTilt")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputBlankingRight", UInt, 0x1636, oscTypeInt)
        OnMessage(0x1636, "_sizingInputBlankingRight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputZoom", UInt, 0x1637, oscTypeInt)
        OnMessage(0x1637, "_sizingInputZoom")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputBlankingBottom", UInt, 0x1638, oscTypeInt)
        OnMessage(0x1638, "_sizingInputBlankingBottom")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputRotate", UInt, 0x1639, oscTypeInt)
        OnMessage(0x1639, "_sizingInputRotate")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputBlankingLeft", UInt, 0x1640, oscTypeInt)
        OnMessage(0x1640, "_sizingInputBlankingLeft")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputFlip", UInt, 0x1641, oscTypeInt)
        OnMessage(0x1641, "_sizingInputFlip")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputWidth", UInt, 0x1642, oscTypeInt)
        OnMessage(0x1642, "_sizingInputWidth")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputHeight", UInt, 0x1643, oscTypeInt)
        OnMessage(0x1643, "_sizingInputHeight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputPitch", UInt, 0x1644, oscTypeInt)
        OnMessage(0x1644, "_sizingInputPitch")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputYaw", UInt, 0x1645, oscTypeInt)
        OnMessage(0x1645, "_sizingInputYaw")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputSmooth", UInt, 0x1646, oscTypeInt)
        OnMessage(0x1646, "_sizingInputSmooth")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputResetSizing", UInt, 0x1647, oscTypeInt)
        OnMessage(0x1647, "_sizingInputResetSizing")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingInputResetCropBlanking", UInt, 0x1648, oscTypeInt)
        OnMessage(0x1648, "_sizingInputResetCropBlanking")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputPan", UInt, 0x1649, oscTypeInt)
        OnMessage(0x1649, "_sizingOutputPan")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputBlankingTop", UInt, 0x1650, oscTypeInt)
        OnMessage(0x1650, "_sizingOutputBlankingTop")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputTilt", UInt, 0x1651, oscTypeInt)
        OnMessage(0x1651, "_sizingOutputTilt")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputBlankingRight", UInt, 0x1652, oscTypeInt)
        OnMessage(0x1652, "_sizingOutputBlankingRight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputZoom", UInt, 0x1653, oscTypeInt)
        OnMessage(0x1653, "_sizingOutputZoom")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputBlankingBottom", UInt, 0x1654, oscTypeInt)
        OnMessage(0x1654, "_sizingOutputBlankingBottom")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputRotate", UInt, 0x1655, oscTypeInt)
        OnMessage(0x1655, "_sizingOutputRotate")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputBlankingLeft", UInt, 0x1656, oscTypeInt)
        OnMessage(0x1656, "_sizingOutputBlankingLeft")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputFlip", UInt, 0x1657, oscTypeInt)
        OnMessage(0x1657, "_sizingOutputFlip")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputWidth", UInt, 0x1658, oscTypeInt)
        OnMessage(0x1658, "_sizingOutputWidth")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputHeight", UInt, 0x1659, oscTypeInt)
        OnMessage(0x1659, "_sizingOutputHeight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputPitch", UInt, 0x1660, oscTypeInt)
        OnMessage(0x1660, "_sizingOutputPitch")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputYaw", UInt, 0x1661, oscTypeInt)
        OnMessage(0x1661, "_sizingOutputYaw")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputSmooth", UInt, 0x1662, oscTypeInt)
        OnMessage(0x1662, "_sizingOutputSmooth")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputResetSizing", UInt, 0x1663, oscTypeInt)
        OnMessage(0x1663, "_sizingOutputResetSizing")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingOutputResetCropBlanking", UInt, 0x1664, oscTypeInt)
        OnMessage(0x1664, "_sizingOutputResetCropBlanking")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodePan", UInt, 0x1665, oscTypeInt)
        OnMessage(0x1665, "_sizingNodePan")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeBlankingTop", UInt, 0x1666, oscTypeInt)
        OnMessage(0x1666, "_sizingNodeBlankingTop")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeTilt", UInt, 0x1667, oscTypeInt)
        OnMessage(0x1667, "_sizingNodeTilt")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeBlankingRight", UInt, 0x1668, oscTypeInt)
        OnMessage(0x1668, "_sizingNodeBlankingRight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeZoom", UInt, 0x1669, oscTypeInt)
        OnMessage(0x1669, "_sizingNodeZoom")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeBlankingBottom", UInt, 0x1670, oscTypeInt)
        OnMessage(0x1670, "_sizingNodeBlankingBottom")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeRotate", UInt, 0x1671, oscTypeInt)
        OnMessage(0x1671, "_sizingNodeRotate")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeBlankingLeft", UInt, 0x1672, oscTypeInt)
        OnMessage(0x1672, "_sizingNodeBlankingLeft")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeFlip", UInt, 0x1673, oscTypeInt)
        OnMessage(0x1673, "_sizingNodeFlip")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeWidth", UInt, 0x1674, oscTypeInt)
        OnMessage(0x1674, "_sizingNodeWidth")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeHeight", UInt, 0x1675, oscTypeInt)
        OnMessage(0x1675, "_sizingNodeHeight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodePitch", UInt, 0x1676, oscTypeInt)
        OnMessage(0x1676, "_sizingNodePitch")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeYaw", UInt, 0x1677, oscTypeInt)
        OnMessage(0x1677, "_sizingNodeYaw")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeKeyLock", UInt, 0x1678, oscTypeInt)
        OnMessage(0x1678, "_sizingNodeKeyLock")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeSmooth", UInt, 0x1679, oscTypeInt)
        OnMessage(0x1679, "_sizingNodeSmooth")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeResetSizing", UInt, 0x1680, oscTypeInt)
        OnMessage(0x1680, "_sizingNodeResetSizing")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingNodeResetCropBlanking", UInt, 0x1681, oscTypeInt)
        OnMessage(0x1681, "_sizingNodeResetCropBlanking")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferencePan", UInt, 0x1682, oscTypeInt)
        OnMessage(0x1682, "_sizingReferencePan")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceBlankingTop", UInt, 0x1683, oscTypeInt)
        OnMessage(0x1683, "_sizingReferenceBlankingTop")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceTilt", UInt, 0x1684, oscTypeInt)
        OnMessage(0x1684, "_sizingReferenceTilt")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceBlankingRight", UInt, 0x1685, oscTypeInt)
        OnMessage(0x1685, "_sizingReferenceBlankingRight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceZoom", UInt, 0x1686, oscTypeInt)
        OnMessage(0x1686, "_sizingReferenceZoom")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceBlankingBottom", UInt, 0x1687, oscTypeInt)
        OnMessage(0x1687, "_sizingReferenceBlankingBottom")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceRotate", UInt, 0x1688, oscTypeInt)
        OnMessage(0x1688, "_sizingReferenceRotate")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceBlankingLeft", UInt, 0x1689, oscTypeInt)
        OnMessage(0x1689, "_sizingReferenceBlankingLeft")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceFlip", UInt, 0x1690, oscTypeInt)
        OnMessage(0x1690, "_sizingReferenceFlip")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceWidth", UInt, 0x1691, oscTypeInt)
        OnMessage(0x1691, "_sizingReferenceWidth")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceHeight", UInt, 0x1692, oscTypeInt)
        OnMessage(0x1692, "_sizingReferenceHeight")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferencePitch", UInt, 0x1693, oscTypeInt)
        OnMessage(0x1693, "_sizingReferencePitch")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceYaw", UInt, 0x1694, oscTypeInt)
        OnMessage(0x1694, "_sizingReferenceYaw")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceSmooth", UInt, 0x1695, oscTypeInt)
        OnMessage(0x1695, "_sizingReferenceSmooth")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceResetSizing", UInt, 0x1696, oscTypeInt)
        OnMessage(0x1696, "_sizingReferenceResetSizing")

        DllCall("OSC2AHK.dll\addListener", AStr, "/sizingReferenceResetCropBlanking", UInt, 0x1697, oscTypeInt)
        OnMessage(0x1697, "_sizingReferenceResetCropBlanking")
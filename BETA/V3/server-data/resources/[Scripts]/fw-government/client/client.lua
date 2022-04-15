-- local LSCore, LoggedIn = exports['fw-base']:GetCoreObject(), false
-- local PlayerJob, DutyBlips = {}, {}
-- local BedData, BedCam, CanCheckin, CanPersonRespawn, ShowingInteraction, CanRecieve = nil, nil, false, false, false, true
-- local InRange, AddedProps, SmeltingProps = false, false, {}


-- Code

-- // Loops \\ --

-- // Events \\ --

-- // Functions \\ --

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
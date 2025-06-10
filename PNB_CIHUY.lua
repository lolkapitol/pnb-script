-- FUNCTION

local function FormatNumber(num)
 num = math.floor(num + 0.5)
 local formatted = tostring(num)
 local k = 3
 while k < #formatted do
 formatted = formatted:sub(1, #formatted - k) .. "," ..
formatted:sub(#formatted - k + 1)
 k = k + 4
 end
 return formatted
end
local function removeColorAndSymbols(str)
 cleanedStr = string.gsub(str, "`(%S)", '')
 cleanedStr = string.gsub(cleanedStr, "`{2}|(~{2})", '')
 return cleanedStr
end
if GetWorld() == nil then
 username = removeColorAndSymbols(player)
else
 username = removeColorAndSymbols(GetLocal().name)
end

-- FUNCTION FOR WEBHOOK

function encodeJson(tbl)
    local function escapeStr(s)
        s = s:gsub("\\", "\\\\")
        s = s:gsub("\"", "\\\"")
        s = s:gsub("\n", "\\n")
        s = s:gsub("\r", "\\r")
        s = s:gsub("\t", "\\t")
        return s
    end

    local function encode(val)
        local t = type(val)
        if t == "nil" then
            return "null"
        elseif t == "number" or t == "boolean" then
            return tostring(val)
        elseif t == "string" then
            return "\"" .. escapeStr(val) .. "\""
        elseif t == "table" then
            local isArray = #val > 0
            local items = {}
            if isArray then
                for i = 1, #val do
                    table.insert(items, encode(val[i]))
                end
                return "[" .. table.concat(items, ",") .. "]"
            else
                for k, v in pairs(val) do
                    table.insert(items, "\"" .. escapeStr(k) .. "\":" .. encode(v))
                end
                return "{" .. table.concat(items, ",") .. "}"
            end
        else
            error("Unsupported type: " .. t)
        end
    end

    return encode(tbl)
end

currentTime = os.time()
currentWorld = (GetWorld() and GetWorld().name) or "UNKNOWN"
previousGem = previousGem or GetPlayerInfo().gems


function playerHook(info)
    currentWorld = (GetWorld() and GetWorld().name) or "UNKNOWN"
    previousGem = previousGem or GetPlayerInfo().gems
    oras = os.time() - currentTime


    if SendWebhook then
        local payload = {
            content = "<@" .. DiscorduserID .. ">",
            username = "PNB Information",
            avatar_url = "https://i.pinimg.com/736x/9c/8a/df/9c8adf2a342c8942d6c349419323b0a0.jpg",
            embeds = {{
                title = "<:rotating_light:1168024326386237470>**PNB Information**",
                color = math.random(1000000, 9999999),
                footer = {
                    text = "Date: " .. os.date("!%A %b %d, %Y | Time: %I:%M %p", os.time() + 8 * 60 * 60) .. " | 4_Rab"
                },
                fields = {
                    {
                        name = "<:exclamation:1178874500629143677> **Information**",
                        value = "World : **" .. currentWorld .. "** Status : **" .. info .. "**",
                        inline = false
                    },
                    {
                        name = "<:bust_in_silhouette:1178875116348768326> Player Name",
                        value = username,
                        inline = false
                    },
                    {
                        name = "<:gem:1178876023253778462> Total Gems",
                        value = "Current Gems: " .. FormatNumber(GetPlayerInfo().gems),
                        inline = false
                    },
                    {
                        name = "<:gem:1178876023253778462> Previous Earned From The PNB",
                        value = "Previous Earned: " .. FormatNumber(GetPlayerInfo().gems - previousGem),
                        inline = false
                    },
                    {
                        name = "<:stopwatch:1167910206647304334> PNB Uptime",
                        value = math.floor(oras / 86400) .. " Days " ..
                                math.floor(oras % 86400 / 3600) .. " Hours " ..
                                math.floor(oras % 3600 / 60) .. " Minutes " ..
                                math.floor(oras % 60) .. " Seconds",
                        inline = false
                    }
                }
            }}
        }

        -- Encode ke JSON dan kirim
        local jsonData = encodeJson(payload)
        MakeRequest(Sendme, "POST", {["Content-Type"] = "application/json"}, jsonData)
    end
end


-- FUNCTION FOR COUNTDOWN
function log(str)
LogToConsole("`7[`8SC OTW"..str)
end

-- CONSUME
function consum(str)
    pkt = {}
        pkt.type = 3
        pkt.value = str
        pkt.flags = 8390688
        pkt.px = GetLocal().pos.x//32
        pkt.py = GetLocal().pos.y//32
        pkt.x = GetLocal().pos.x
        pkt.y = GetLocal().pos.y
        SendPacketRaw(false,pkt)
end

-- ONTEXT
function ontext(str)
    on = {}
    on [0] = "OnTextOverlay"
    on [1] = str
    SendVariantList(on)
end

-- WRENCH
function wrench()
    pkt = {}
    pkt.type = 3
    pkt.value = 32
    pkt.state = 8
    pkt.px = Mag[count].x
    pkt.py = Mag[count].y
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end

-- GETMAG Normal
function GetMagN()
    Mag = {}
    count = 0
    for _, tile in pairs(GetTiles()) do
        if (tile.fg == 5638) and (tile.bg == bg) then
            count = count + 1
            Mag[count] = {x = tile.x, y = tile.y}
        end
    end
end

-- GETMAG Island
function GetMag()
    Mag = {}
    count = 0
    for x = 0, 199 do
        for y = 0, 199 do
            tile = GetTile(x, y)
            if (tile.fg == 5638) and (tile.bg == bg) then
                count = count + 1
                Mag[count] = {x = tile.x, y = tile.y}
            end
        end
    end
end

-- AUTO CHECK ISLAND OR NOT
local status , err = pcall(GetMag)
if not status then
    iorn = "Normal"
Sleep(1000)
    GetMagN()
else
    iorn = "Island"
end

-- CHEATS
function scheat()
    if (cheats == true) and (math.floor(GetLocal().pos.x//32) == xawal) and (math.floor(GetLocal().pos.y//32) == yawal) then
        Sleep(700)
        SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_lonely|" .. hide .. "\ncheck_gems|" .. dbg .. "\ncheck_ignoreo|" .. hide .. "\ncheck_ignoref|" .. hide)
        Sleep(300)
        cheats = false
    end
end

function fmag()
    if FindPath(Mag[count].x , Mag[count].y - 1) == true then
        Sleep(200)
        ontext("`cSearching Magplant...")
        Sleep(300)
        findmag = false
        takeremote = true
    else
        LogToConsole("`8[ `bError 404 `8]")
        SendVariantList({[0] = "OnTalkBubble", [1] = GetLocal().netID, [2] = "`4Restart/Rerun !!!"})
        findmag = false
    end
end

-- TAKE REMOTE
function tremote()
    Sleep(500)
    if (takeremote  == true) then
        if math.floor(GetLocal().pos.x//32) == Mag[count].x and math.floor(GetLocal().pos.y//32) == Mag[count].y - 1 then
            Sleep(300)
            wrench()
            Sleep(100)
        if nono == false then
            ontext("`8[ `cSuccess Take Remote `8]")
            SendPacket(2,"action|dialog_return\ndialog_name|magplant_edit\nx|"..Mag[count].x.."|\ny|"..Mag[count].y.."|\nbuttonClicked|getRemote\n\n")
            takeremote = false
        elseif nono == true then
            ontext("`cLoading...")
            nono = false
            takeremote = false
            findmag = false
        end
        else
            ontext("`4Don't Move !!!")
            SendVariantList({[0] = "OnTalkBubble", [1] = GetLocal().netID, [2] = "Please Re run the script or Re enter World"})
            takeremote = false
        end
    end
end

-- ADDHOOK
AddHook("onvariant", "hook", function(var)
    if var[0] == "OnConsoleMessage" and var[1]:find("World Locked") then
        findmag = true
        return true
    end
    if var[0] == "OnConsoleMessage" and var[1]:find("Where would you like to go?") then
        getworld = true
        return true
    end
    if var[0] == "OnConsoleMessage" and var[1]:find("Your stomach's rumbling.") then
        if Autoconsume == true then
            consum(528)
            Sleep(500)
            consum(1474)
            Sleep(500)
            consum(4604)
            ontext("`8[ `cAuto Eat Arroz `8]")
            return true
        end
    end
    if var[0] == "OnTalkBubble" and var[2]:find("You received a MAGPLANT 5000 Remote.") then
        cheats = true
        return true
    end
    if var[0] == "OnTalkBubble" and var[2]:find("The MAGPLANT 5000 is empty.") then
        empty = true
        return true
    end
    if var[0] == "OnDialogRequest" and var[1]:find("The machine contains") then
        return true
    end
    return false
end)



-- START SCRIPT
playerHook("Running Script")
log("`2 in : `43`7]")
Sleep(1000)
log("`2 in : `42`7]")
Sleep(1000)
log("`2 in : `41`7]")
Sleep(1000)
-- SEND DIALOG
opening = [[
add_label_with_icon|big|`2PNB ADVANCE |left|]] .. 11816 ..[[|
add_spacer|small|
add_textbox|`0CREDITS|
add_textbox|`2[-] `9Owner `0: `#@Doctorr|
add_textbox|`2[-] `9Asisten `0: `b@SangMahaRajaGanoel|
add_textbox|`0Hello `2]]..GetLocal().name..[[ `0Thanks For Using This Script |left|
add_spacer|small|
add_textbox|`9Script Info & Rules:|left|
add_label_with_icon|small|`0Do not `4Resell `0or `4Share `0My Script|left|7190|
add_label_with_icon|small|`0World Types       : `2]]..iorn..[[|left|3802|
add_label_with_icon|small|`0World Name      : `2]]..World..[[|left|10078|
add_label_with_icon|small|`0Mags Counted  : `2]]..count..[[|left|5638|
add_spacer|small|
end_dialog|itro|Close|                   OKE                   |
]]
s = {}
s [0] = "OnDialogRequest"
s [1] = opening
SendVariantList(s)
Sleep(3000)
SendPacket(2,"action|input\n|text|`8[ `cSC PNB ON BY `#@Doctorr `8]")
SendVariantList({[0] = "OnTalkBubble", [1] = GetLocal().netID , [2] = "`8[ `cSCRIPT PNB ADVANCE by `bSangMahaRajaGanoel `8]"})
SendVariantList({[0] = "OnTalkBubble", [1] = GetLocal().netID , [2] = "`8[ `cSCRIPT PNB ADVANCE by `bDoctorr `8]"})
if Autoconsume == true then
consum(1474)
Sleep(500)
consum(528)
Sleep(600)
consum(4604)
Sleep(300)
elseif Autoconsume == false then
ontext("`8Auto Consume Clover Is Not Enable")
end
Sleep(3000)
-- WHILE LOOP
fmag()
while true do
    Sleep(2000)
    if count > 0 then
        if (getworld == true) then
            ontext("`8[ `cGoing to `8"..World.." `c]")
            SendPacket(3, "action|join_request\nname|"..World.."\ninvitedWorld|0")
            playerHook("Disconnect")
            Sleep(3000)
            getworld = false
        end
        if (findmag == true) then
            Sleep(200)
            fmag()
        end
        if (cheats == true) then
            FindPath(xawal,yawal)
            playerHook("Mulai PNB")
            Sleep(200)
            scheat()
        end
        if (takeremote == true) then
            playerHook("Mengambil Remote")
            tremote()
            Sleep(1000) 
        end
        if (empty == true) then
            SendPacket(2,"action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0")
            Sleep(400)
            count = count - 1
            empty = false
            findmag = true
        end
        if (nothing == true) then
            Sleep(800)
            count = count - 1
            nothing = false
            findmag = true
        end
    else
        ontext("All magplant empty")
        playerHook("Semua Magplant Sudah Habis")
        SendVariantList({[0] = "OnTalkBubble", [1] = GetLocal().netID , [2] = "`8[ `cAll Magplant Empty`8]"})
    end
end
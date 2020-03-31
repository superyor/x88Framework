--[[
# DON'T BE A DICK PUBLIC LICENSE

> Version 1.1, December 2016

> Copyright (C) [2020] [Janek "superyu"]

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document.

> DON'T BE A DICK PUBLIC LICENSE
> TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

1. Do whatever you like with the original work, just don't be a dick.

   Being a dick includes - but is not limited to - the following instances:

 1a. Outright copyright infringement - Don't just copy this and change the name.
 1b. Selling the unmodified original with no work done what-so-ever, that's REALLY being a dick.
 1c. Modifying the original work to contain hidden harmful content. That would make you a PROPER dick.

2. If you become rich through modifications, related works/services, or supporting the original work,
share the love. Only a dick would make loads off this work and not buy the original work's
creator(s) a pint.

3. Code is provided with no warranty. Using somebody else's code and bitching when it goes wrong makes
you a DONKEY dick. Fix the problem yourself. A non-dick would submit the fix back.
]]

--[[
    ---INSTRUCTIONS---
    Hey, this is an x88 style menu framework. Currently you can only use boolSwitches
    and sliders but this will change in the future. Right now the multibox:get_value()
    returns a string, if an option to make it return an integer becomes available I will
    update this.

    Now lets talk about how to use this.
    This is my first GUI Framework so if you find bugs then report them.
    I tried building it up in an object structure.
    The oMenu object is basically the menu.
    There is rows and columns, current row current column for the selection and a VARS table where all gui objects are stored.
    There is also a keystates table. I SUGGEST NOT TOUCHING ANY OF THOSE TABLES WITH EXECPTION OF THE X AND Y TABLE!!!

    The good thing about this framework is, you don't need to hardcode anything. 
    You create the oMenu, then you simply create for example a boolSwitch (checkbox) in the on_paint with

    oMenu.addBoolSwitch(name, varname, guiObject, defaultValue)

    or to put it into actual useable code:

    oMenu.addBoolSwitch("Bhop", "x88.bhop", gui.get_checkbox("misc", "bhop"), false)

    As you can see, it's very simple to use this framework.
    Now have fun making your own x88 styled menu! :D
]]

--- Keybox.
local keybox = gui.new_keybox("x88 Framework - Menu Key", "x88framework_menukey");

--- Menu Object
local oMenu = {
    ["VISIBLE"] = false,
    ["X"] = -100,
    ["Y"] = 25,
    ["ROW"] = 0,
    ["COLUMN"] = 0,
    ["CURRENTROW"] = 0,
    ["CURRENTCOLUMN"] = 1,
    ["ROWSINCOLUMN"] = {},
    ["COLUMNSINROW"] = {},
    ["VARS"] = {},

    ["KEYSTATES"] = {
        ["BACKSPACE"] = false,
        ["ENTER"] = false,
        ["LEFTARROW"] = false,
        ["UPARROW"] = false,
        ["RIGHTARROW"] = false,
        ["DOWNARROW"] = false,
    },

    ["LASTKEYSTATES"] = {}
}

--- Font creation
renderer.new_font("menufont", "Tahoma", 13, 500, fontflags.outline)

--- API Localization
local getKeyState = input_handler.is_key_pressed;
local renderText = renderer.text

--- Handle input for keycode and set keystate to true/false.
function oMenu.handleInput(keycode, value)
    local isActive = getKeyState(keycode)
    if oMenu["LASTKEYSTATES"][value] == nil then
        if isActive and oMenu["LASTKEYSTATES"][keycode] == false then
            oMenu["KEYSTATES"][value] = true;
        else
            oMenu["KEYSTATES"][value] = false;
        end
    end
    oMenu["LASTKEYSTATES"][keycode] = isActive
end

function oMenu.tableLength()
    local count = 0
    for kek in pairs(table) do count = count + 1 end
    return count
end

function oMenu.percentageColor(color1, color2, percent)
    if percent > 1 then
        percent = 1
    elseif percent < 0 then
        percent = 0
    end
    local r, g, b = color1.r-(color1.r-color2.r)*percent, color1.g-(color1.g-color2.g)*percent, color1.b-(color1.b-color2.b)*percent
    return color.new(math.floor(r), math.floor(g), math.floor(b), 255)
end

--- Add a boolswitch, basically a checkbox.
function oMenu.addBoolSwitch(name, value, guiObject, default)
    if oMenu["VARS"][value] == nil then
        oMenu["VARS"][value] = guiObject;
        oMenu["VARS"][value]:set_value(default);
    end

    local x, y = oMenu["X"]+(200*oMenu["COLUMN"]), oMenu["Y"]+(25*oMenu["ROW"])

    if oMenu["CURRENTROW"] == oMenu["ROW"] and oMenu["CURRENTCOLUMN"] == oMenu["COLUMN"] then
        if oMenu["KEYSTATES"]["ENTER"] then
            oMenu["VARS"][value]:set_value(not oMenu["VARS"][value]:get_value());
        end
        renderText(x, y, color.new(255, 255, 25, 255), name, fonts.menufont, 0, 1);
    else
        renderText(x, y, color.new(255, 255, 255, 255), name, fonts.menufont, 0, 1)
    end

    if oMenu["VARS"][value]:get_value() then
        renderText(x+150, y, color.new(25, 255, 25, 255), "ON", fonts.menufont, 1, 1)
    else
        renderText(x+150, y, color.new(255, 25, 25, 255), "OFF", fonts.menufont, 1, 1)
    end

    oMenu["COLUMNSINROW"][oMenu["ROW"]] = oMenu["COLUMN"]
    oMenu["ROW"] = oMenu["ROW"] + 1;
end

--- Slider
function oMenu.addSlider(name, value, guiObject, default, minValue, maxValue)
    if oMenu["VARS"][value] == nil then
        oMenu["VARS"][value] = guiObject;
        oMenu["VARS"][value]:set_value(default);
    end

    local x, y = oMenu["X"]+(200*oMenu["COLUMN"]), oMenu["Y"]+(25*oMenu["ROW"])

    if oMenu["CURRENTROW"] == oMenu["ROW"] and oMenu["CURRENTCOLUMN"] == oMenu["COLUMN"] then
        if oMenu["KEYSTATES"]["ENTER"] then
            if oMenu["VARS"][value]:get_value()+1 <= maxValue then
                oMenu["VARS"][value]:set_value(oMenu["VARS"][value]:get_value()+1);
            end
        end

        if oMenu["KEYSTATES"]["BACKSPACE"] then
            if oMenu["VARS"][value]:get_value()-1 >= minValue then
                oMenu["VARS"][value]:set_value(oMenu["VARS"][value]:get_value()-1);
            end
        end

        renderText(x, y, color.new(255, 255, 25, 255), name, fonts.menufont, 0, 1);
    else
        renderText(x, y, color.new(255, 255, 255, 255), name, fonts.menufont, 0, 1)
    end

    local color = oMenu.percentageColor(color.new(255, 25, 25, 255), color.new(25, 255, 25, 255), (oMenu["VARS"][value]:get_value()-minValue)/(maxValue-minValue))
    renderText(x+150, y, color, tostring(oMenu["VARS"][value]:get_value()), fonts.menufont, 1, 1)

    oMenu["COLUMNSINROW"][oMenu["ROW"]] = oMenu["COLUMN"]
    oMenu["ROW"] = oMenu["ROW"] + 1;
end

--- An multiSwitch, basically a multibox
--- DO NOT USE THIS, THIS IS CURRENTLY NOT WORKING!!!!!!!!!!!!!
--[[
function oMenu.addMultiSwitch(name, value, guiObject, default, optionsTable)
    if oMenu["VARS"][value] == nil then
        oMenu["VARS"][value] = guiObject;
        oMenu["VARS"][value]:set_value(default);
    end

    local x, y = oMenu["X"]+(200*oMenu["COLUMN"]), oMenu["Y"]+(25*oMenu["ROW"])

    if oMenu["CURRENTROW"] == oMenu["ROW"] and oMenu["CURRENTCOLUMN"] == oMenu["COLUMN"] then

        if oMenu["KEYSTATES"]["ENTER"] then
            if oMenu["VARS"][value]:get_value()+1 <= oMenu.tableLength(optionsTable) then
                oMenu["VARS"][value]:set_value(oMenu["VARS"][value]:get_value()+1);
            end
        end

        if oMenu["KEYSTATES"]["BACKSPACE"] then
            if oMenu["VARS"][value]:get_value()-1 >= 0 then
                oMenu["VARS"][value]:set_value(oMenu["VARS"][value]:get_value()-1);
            end
        end

        renderText(x, y, color.new(255, 255, 25, 255), name, fonts.menufont, 0, 1);
    else
        renderText(x, y, color.new(255, 255, 255, 255), name, fonts.menufont, 0, 1)
    end

    for k, v in pairs(optionsTable) do
        if k == oMenu["VARS"][value]:get_value() then
            renderText(x+150+(150*k), y, color.new(25, 255, 25, 255), v, fonts.menufont, 1, 1)
        else
            renderText(x+150+(150*k), y, color.new(255, 255, 255, 255), v, fonts.menufont, 1, 1)
        end
    end

    oMenu["COLUMNSINROW"][oMenu["ROW"]] --[[= oMenu["COLUMN"]
    oMenu["ROW"] = oMenu["ROW"] + 1;
end]]

--- Start a new column in the menu
function oMenu.nextColumn()
    oMenu["ROWSINCOLUMN"][oMenu["COLUMN"]] = oMenu["ROW"]
    oMenu["COLUMN"] = oMenu["COLUMN"] + 1
    oMenu["ROW"] = 0;
    return true;
end

--- Create the menu, update keystates.
function oMenu.Create()

    oMenu.handleInput(keybox:get_value(), "MENUKEY");
    if oMenu["KEYSTATES"]["MENUKEY"] then
        oMenu["VISIBLE"] = not oMenu["VISIBLE"];
    end

    if oMenu["VISIBLE"] then
        oMenu.handleInput(8, "BACKSPACE")
        oMenu.handleInput(13, "ENTER")
        oMenu.handleInput(37, "LEFTARROW")
        oMenu.handleInput(38, "UPARROW")
        oMenu.handleInput(39, "RIGHTARROW")
        oMenu.handleInput(40, "DOWNARROW")

        oMenu["ROWSINCOLUMN"][oMenu["COLUMN"]] = oMenu["ROW"]

        if oMenu["KEYSTATES"]["LEFTARROW"] then
            if oMenu["CURRENTCOLUMN"] > 1 then
                oMenu["CURRENTCOLUMN"] = oMenu["CURRENTCOLUMN"] - 1
            end
        end

        if oMenu["KEYSTATES"]["RIGHTARROW"] then
            if oMenu["CURRENTCOLUMN"] < oMenu["COLUMN"] then
                if oMenu["COLUMNSINROW"][oMenu["CURRENTROW"]] > oMenu["CURRENTCOLUMN"] then
                    oMenu["CURRENTCOLUMN"] = oMenu["CURRENTCOLUMN"] + 1
                end
            end
        end

        if oMenu["KEYSTATES"]["UPARROW"] then
            if oMenu["CURRENTROW"] > 0 then
                oMenu["CURRENTROW"] = oMenu["CURRENTROW"] - 1
            end
        end

        if oMenu["KEYSTATES"]["DOWNARROW"] then
            if oMenu["ROWSINCOLUMN"][oMenu["CURRENTCOLUMN"]] ~= nil then
                if oMenu["CURRENTROW"] < oMenu["ROWSINCOLUMN"][oMenu["CURRENTCOLUMN"]] - 1 then
                    oMenu["CURRENTROW"] = oMenu["CURRENTROW"] + 1
                end
            end
        end

        oMenu["ROW"] = 0
        oMenu["COLUMN"] = 1;
        return true;
    else
        return false;
    end
end

function on_paint()

    --[[

    EXAMPLE USAGE

    if oMenu.Create() then

        oMenu.addBoolSwitch("Bhop", "x88.bhop", gui.get_checkbox("misc", "bhop"), false)
        oMenu.addBoolSwitch("Clantag", "x88.clantag", gui.get_checkbox("misc", "clantag_changer"), true)
        oMenu.addSlider("Thirdperson Distance", "x88.tpdistance", gui.get_slider("local_visuals", "thirdperson_distance"), 55, 50, 60)

        if oMenu.nextColumn() then
            oMenu.addBoolSwitch("Bhop", "x88.bhop2", gui.get_checkbox("misc", "bhop"), false)
        end
    end

    ]]

    --- You can make your own menu here



end
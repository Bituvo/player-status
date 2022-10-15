local storage = minetest.get_mod_storage()
local prefix = "playerstatus_"

-- Set to false to disable announcing status changes
local announce_status = true

-- Function to see if a player has a certain status
local function check_status(name, status)
    return storage:get_string(prefix .. name):lower() == status:lower()
end

-- Show a player their status when they join the server
minetest.register_on_joinplayer(function(name)
    local player_name = name:get_player_name()
    local status = storage:get_string(prefix .. player_name)

    if (status ~= '') then
        minetest.chat_send_player(player_name, "Your status is " .. status)
    end
end)

minetest.register_chatcommand("set_status", {
    description = "Set your public in-game status",

    privs = {
        shout = true;
    },

    func = function(name, status)
        if check_status(name, status) then
            minetest.chat_send_player(name, "That is already your status")
        else
            storage:set_string(prefix .. name, status)

            if announce_status then
                if (status == '') then
                    minetest.chat_send_all(name .. " has cleared their status")
                else
                    minetest.chat_send_all(name .. " is " .. status)
                end
            end
        end

        return true
    end
})

minetest.register_chatcommand("afk", {
    description = "Set your public in-game status to AFK",

    privs = {
        shout = true;
    },

    func = function(name)
        if check_status(name, "afk") then
            minetest.chat_send_player(name, "You are already AFK")
        else
            storage:set_string(prefix .. name, "AFK")

            if announce_status then
                minetest.chat_send_all(name .. " is AFK")
            end
        end

        return true
    end
})

minetest.register_chatcommand("get_status", {
    description = "Get a players' in-game status",

    privs = {
        interact = true;
    },

    func = function(invoker, name)
        -- If no name is given, tell the invoker their status
        if (name == "") then
            if check_status(invoker, "") then
                minetest.chat_send_player(invoker, "You have no status")
            else
                minetest.chat_send_player(invoker, "Your status is " .. storage:get_string(prefix .. invoker))
            end
        else
            -- Only give a player's status if they are logged in
            if minetest.get_player_by_name(name) then
                if check_status(name, "") then
                    minetest.chat_send_player(invoker, name .. " has no status")
                else
                    minetest.chat_send_player(invoker, name .. " is " .. storage:get_string(prefix .. name))
                end
            else
                minetest.chat_send_player(invoker, name .. " is not logged in")
            end
        end

        return true
    end
})

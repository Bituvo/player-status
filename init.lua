local storage = minetest.get_mod_storage()
local prefix = "playerstatus_"

minetest.register_chatcommand("set_status", {
    description = "Set your public in-game status",

    privs = {
        shout = true;
    },

    func = function(name, status)
        storage:set_string(prefix .. name, status)
        minetest.chat_send_all(name .. " is " .. status)

        return true
    end
})

minetest.register_chatcommand("get_status", {
    description = "Get a players' in-game status",

    privs = {
        interact = true;
    },

    func = function(invoker, name)
        minetest.chat_send_player(invoker, name .. " is " .. storage:get_string(prefix .. name))

        return true
    end
})

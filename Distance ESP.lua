-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_eye_position, client_screen_size, client_set_event_callback, client_trace_bullet, client_trace_line, entity_get_local_player, entity_get_players, entity_hitbox_position, renderer_line, renderer_world_to_screen, ui_get, ui_new_checkbox, ui_new_multiselect, ui_new_color_picker, ui_new_combobox, ui_new_slider, ui_reference, ui_set_callback, ui_set_visible, ipairs, entity_get_prop, math_sqrt, math_abs, math_min, math_max = client.eye_position, client.screen_size, client.set_event_callback, client.trace_bullet, client.trace_line, entity.get_local_player, entity.get_players, entity.hitbox_position, renderer.line, renderer.world_to_screen, ui.get, ui.new_checkbox, ui.new_multiselect, ui.new_color_picker, ui.new_combobox, ui.new_slider, ui.reference, ui.set_callback, ui.set_visible, ipairs, entity.get_prop, math.sqrt, math.abs, math.min, math.max

local teammates = ui_reference("VISUALS", "Player ESP", "Teammates")
local menu_enabled = ui_new_checkbox("VISUALS", "Player ESP", "ESP distance")

local hitboxes = {
    "Head",
    "Neck",
    "Pelvis",
    "Spine 0",
    "Spine 1",
    "Spine 2",
    "Spine 3",
    "Upper Left Leg",
    "Upper Right Leg",
    "Lower Left Leg",
    "Lower Right Leg",
    "Left Ankle",
    "Right Ankle",
    "Left Hand",
    "Right Hand",
    "Upper Left Arm",
    "Lower Left Arm",
    "Upper Right Arm",
    "Lower Right Arm"
}

local menu_hitbox_tracers = ui_new_multiselect("VISUALS", "Player ESP", "Hitbox", hitboxes)
local distanceslider = ui_new_slider("VISUALS", "Player ESP", "Distance", 0, 100, 50, true)

function indexIn(t,val)
    for k,v in ipairs(t) do 
        if v == val then return k end
    end
end

local function distance3d(x1, y1, z1, x2, y2, z2)
    local x, y, z = math_abs(x1-x2), math_abs(y1-y2), math_abs(z1-z2)
    return math_sqrt(x*x+y*y+z*z)
end

client_set_event_callback("paint", function(ctx)
    if not ui_get(menu_enabled) then
    return end
    local players = entity_get_players(not ui_get(teammates))
    if #players == nil then 
    return end

    local me = entity_get_local_player()
    local trace_hitboxes = ui_get(menu_hitbox_tracers)

    for i = 1, #players do 
        if players[i] ~= me then
            local player_lines = {}
            local last_dist = math.huge
            for n = 1, #trace_hitboxes do
                local hbox_x, hbox_y, hbox_z = entity_hitbox_position(players[i], indexIn(hitboxes, trace_hitboxes[n])-1)
                local me_x, me_y, me_z = client_eye_position()
                local xa, ya = renderer_world_to_screen(hbox_x, hbox_y, hbox_z)

                if xa ~= nil then
                    local w, h = client_screen_size()
                    local distance = distance3d(me_x, me_y, me_z, hbox_x, hbox_y, hbox_z)

                    if distance <= (ui.get(distanceslider) * 10) then
                        renderer.rectangle(xa - 4, ya - 40, 8, 50, 255, 0, 0, 255)
                        renderer.rectangle(xa - 4, ya + 20, 8, 8, 255, 0, 0, 255)
                        --renderer.text(xa, ya, 255, 0, 0, 255, "+", 0, "!")
                    end
                end
            end
        end
    end
end)

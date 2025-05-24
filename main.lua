-- name: [CS] TOTSUGEKI 64
-- description: A Character Select Port of Totugeki 64, featuring May from the Guilty Gear Series.\nOriginal by: spk\nhttps://romhacking.com/hack/TOTSUGEKI-64 
-- incompatible: 
-- category: cs

if not _G.charSelectExists then
    return 0
end

local E_MODEL_DOLPHIN = smlua_model_util_get_id("dolphin_totsugeki_geo")
local E_MODEL_MAY = smlua_model_util_get_id("may_totsugeki_geo")

local TEX_ICON_MAY = get_texture_info("icon-may-totsugeki")

local VOICETABLE_MAY = {
    [CHAR_SOUND_YAH_WAH_HOO] = {"02_may_yah.ogg", "01_may_jump_wah.ogg", "00_may_jump_hoo.ogg"},
    [CHAR_SOUND_HOOHOO] = "01_may_hoohoo.ogg",
    [CHAR_SOUND_YAHOO] = "04_may_yahoo.ogg",
    [CHAR_SOUND_UH] = "05_may_uh.ogg",
    [CHAR_SOUND_HRMM] = "06_may_hrmm.ogg",
    [CHAR_SOUND_WAH2] = "07_may_wah2.ogg",
    [CHAR_SOUND_WHOA] = "08_may_whoa.ogg",
    [CHAR_SOUND_EEUH] = "09_may_eeuh.ogg",
    [CHAR_SOUND_ATTACKED] = "0A_may_attacked.ogg",
    [CHAR_SOUND_OOOF] = "0B_may_ooof.ogg",
    --[CHAR_SOUND_OOOF2] = "",
    [CHAR_SOUND_HERE_WE_GO] = "0C_may_here_we_go.ogg",
    [CHAR_SOUND_YAWNING] = "0D_may_yawning.ogg",
    [CHAR_SOUND_SNORING1] = "0E_may_snoring1.ogg",
    [CHAR_SOUND_SNORING2] = "0F_may_snoring2.ogg",
    [CHAR_SOUND_WAAAOOOW] = "00_may_waaaooow.ogg",
    [CHAR_SOUND_HAHA] = "03_may_haha.ogg",
    --[CHAR_SOUND_HAHA_2] = "",
    [CHAR_SOUND_UH2] = "05_may_uh2.ogg",
    [CHAR_SOUND_UH2_2] = "05_may_uh2.ogg",
    [CHAR_SOUND_ON_FIRE] = "04_may_on_fire.ogg",
    [CHAR_SOUND_DYING] = "03_may_dying.ogg",
    --[CHAR_SOUND_PANTING_COLD] = "",
    [CHAR_SOUND_PANTING] = "02_may_panting.ogg",
    [CHAR_SOUND_COUGHING1] = "06_may_coughing.ogg",
    --[CHAR_SOUND_COUGHING2] = "",
    --[CHAR_SOUND_COUGHING3] = "",
    [CHAR_SOUND_PUNCH_YAH] = "08_may_punch_yah.ogg",
    [CHAR_SOUND_PUNCH_HOO] = "09_may_punch_hoo.ogg",
    [CHAR_SOUND_MAMA_MIA] = "0A_may_mama_mia.ogg",
    [CHAR_SOUND_OKEY_DOKEY] = "0B_may_okey_dokey.ogg",
    --[CHAR_SOUND_GROUND_POUND_WAH] = "",
    [CHAR_SOUND_DROWNING] = "0C_may_drowning.ogg",
    --[CHAR_SOUND_PUNCH_WAH] = "",
    [CHAR_SOUND_YAHOO_WAHA_YIPPEE] = {"04_may_yahoo.ogg", "18_may_waha.ogg", "19_may_yippee.ogg"},
    [CHAR_SOUND_DOH] = "10_may_doh.ogg",
    [CHAR_SOUND_GAME_OVER] = "11_may_game_over.ogg",
    [CHAR_SOUND_HELLO] = "12_may_hello.ogg",
    [CHAR_SOUND_PRESS_START_TO_PLAY] = "13_may_press_start_to_play.ogg",
    [CHAR_SOUND_TWIRL_BOUNCE] = "14_may_twirl_bounce.ogg",
    [CHAR_SOUND_SNORING3] = "15_may_snoring3.ogg",
    [CHAR_SOUND_SO_LONGA_BOWSER] = "16_may_so_longa_bowser.ogg",
    [CHAR_SOUND_IMA_TIRED] = "17_may_ima_tired.ogg",
    [CHAR_SOUND_LETS_A_GO] = "1A_may_lets_a_go.ogg",
}

local CT_MAY = _G.charSelect.character_add("May", nil, "spktk", nil, E_MODEL_MAY, nil, TEX_ICON_MAY, 1)
_G.charSelect.character_add_voice(E_MODEL_MAY, VOICETABLE_MAY)
_G.charSelect.config_character_sounds()

local gMayStates = {}
for i = 0, MAX_PLAYERS - 1 do
    gMayStates[i] = {
        totsuUnlocked = true,
        canTotsu = true,
        totsuTimer = 30,
    }
end

local ACT_TOTSUGEKI = allocate_mario_action(0x030008BF) -- Proper act flags weren't defined in the source code

-- Dolphin

define_custom_obj_fields({
    oPlayerIndex = 'u32',
})

local function bhv_dolphin_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj_scale_xyz(o, 0.0, 0.0, 0.0);
end

local function bhv_dolphin_loop(o)
    local m = gMarioStates[o.oPlayerIndex];
    local xScale = o.header.gfx.scale.x;
    local yScale = o.header.gfx.scale.y;
    local zScale = o.header.gfx.scale.z;
    local marioX = m.pos.x;
    local marioY = m.pos.y;
    local marioZ = m.pos.z;
    obj_set_pos(o, marioX, marioY + (-85.0 * yScale), marioZ);
    o.oFaceAngleYaw = m.faceAngle.y;


    if (m.action ~= ACT_TOTSUGEKI) then
        if (yScale > 0.0) then
            yScale = yScale - 0.15;
        end
        if (xScale > 0.0) then
            xScale = xScale - 0.15;
        end
        if (zScale > 0.0) then
            zScale = zScale - 0.15;
        end
        if (yScale <= 0.0) then
            obj_mark_for_deletion(o);
        end

    else
        if (yScale < 1.0) then
            yScale = yScale + 0.1;
        end
        if (xScale < 1.0) then
            xScale = xScale + 0.1;
        end
        if (zScale < 1.0) then
            zScale = zScale + 0.1;
        end
    end

    obj_scale_xyz(o, xScale, yScale, zScale);
end

local id_bhvDolphin = hook_behavior(nil, OBJ_LIST_DEFAULT, true, bhv_dolphin_init, bhv_dolphin_loop, "id_bhvDolphin")

local function act_totsugeki(m)
    local e = gMayStates[m.playerIndex]
    if (m.actionTimer == 0) then
        m.vel.y = 45.0;
        e.canTotsu = false;
        m.usedObj = spawn_non_sync_object(id_bhvDolphin, E_MODEL_DOLPHIN, m.pos.x, m.pos.y, m.pos.z, 
            function(o)
                o.oPlayerIndex = m.playerIndex
            end)
        if ((random_u16() % 2) == 1) then
            play_character_sound(m, CHAR_SOUND_PRESS_START_TO_PLAY) 
        else
            play_character_sound(m, CHAR_SOUND_SO_LONGA_BOWSER) 
        end
        e.totsuTimer = 30;
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_DIVE, 0);
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_GROUND_POUND, 0);
    end

    if ((m.controller.buttonPressed & L_TRIG) ~= 0 and m.actionTimer >= 5) then
        return set_mario_action(m, ACT_FREEFALL, 0);
    end

    set_mario_animation(m, MARIO_ANIM_DIVE);

    mario_set_forward_vel(m, 60.0);

    if (m.vel.y > 0.0) then
        m.vel.y = m.vel.y - 4.0;
    else
        m.vel.y = 0.0;
    end

    if (m.actionTimer >= 5) then
        m.flags = m.flags | MARIO_KICKING;
    end

    update_air_without_turn(m);

    local step = (perform_air_step(m, 0))
    if step == AIR_STEP_LANDED then
        m.actionState = m.actionState + 1
        if (m.actionState == 0) then
            m.vel.y = 42.0;
        else
            set_mario_action(m, ACT_FREEFALL_LAND_STOP, 0);
        end
        play_mario_landing_sound(m, SOUND_ACTION_TERRAIN_LANDING);
    end
    if step == AIR_STEP_HIT_WALL then
        mario_bonk_reflection(m, false);
    end

    if (m.actionTimer > e.totsuTimer) then
        return set_mario_action(m, ACT_FREEFALL, 0);
    end

    m.actionTimer = m.actionTimer + 1;

    return false;
end

hook_mario_action(ACT_TOTSUGEKI, {every_frame = act_totsugeki});

-- Original Code had totsugeki embedded in the original SM64 actions
local canTotsuList = {
    [ACT_JUMP] = true,
    [ACT_DOUBLE_JUMP] = true,
    [ACT_TRIPLE_JUMP] = true,
    [ACT_BACKFLIP] = true,
    [ACT_FREEFALL] = true,
    [ACT_SIDE_FLIP] = true,
    [ACT_WALL_KICK_AIR] = true,
    [ACT_LONG_JUMP] = true,
    [ACT_TWIRLING] = true,
    [ACT_WATER_JUMP] = true,
    [ACT_GROUND_POUND] = true,
}

local function may_update(m)
    local e = gMayStates[m.playerIndex]
    if canTotsuList[m.action] and ((m.controller.buttonDown & L_TRIG) ~= 0 and e.canTotsu and e.totsuUnlocked) then
        set_mario_action(m, ACT_TOTSUGEKI, 0);
    end
    if m.action & ACT_FLAG_AIR == 0 then
        e.canTotsu = true;
    end
end

_G.charSelect.character_hook_moveset(CT_MAY, HOOK_MARIO_UPDATE, may_update);
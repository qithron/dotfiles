local settings = {

    -- #### FUNCTIONALITY SETTINGS
    --
    filename_replace = "",

    --json array of filetypes to search from directory
    --use empty string in array to search any(not recommended)
    loadfiles_filetypes = [[
    [
    "mkv", "avi", "mp4", "ogv", "webm", "rmvb", "flv", "wmv",
    "mpeg", "mpg", "m4v", "3gp","mp3", "wav", "ogv", "flac",
    "m4a", "wma", "jpg", "gif", "png", "jpeg", "webp"
    ]
    ]],

    --loadfiles at startup if there is 0 or 1 items in playlist, if 0 uses worḱing dir for files
    loadfiles_on_start = false,

    --sort playlist on mpv start
    sortplaylist_on_start = true,

    --sort playlist when files are added to playlist
    sortplaylist_on_file_add = true,

    --use alphanumerical sort
    alphanumsort = true,

    --linux=true, windows=false
    linux_over_windows = true,

    --show playlist every time a new file is loaded
    --NOTE: using osd-playing-message will interfere with this setting, if you prefer it use 0 here
    --2 shows playlist, 1 shows current file(filename strip applied), 0 shows nothing
    --instead of using this you can also call script-message playlistmanager show playlist/filename
    --ex. KEY playlist-next ; script-message playlistmanager show playlist
    show_playlist_on_fileload = 0,

    --sync cursor when file is loaded from outside reasons(file-ending, playlist-next shortcut etc.)
    --has the sideeffect of moving cursor if file happens to change when navigating
    --good side is cursor always following current file when going back and forth files with playlist-next/prev
    sync_cursor_on_load = true,

    --keybindings force override only while playlist is visible
    --allowing you to use common overlapping keybinds
    dynamic_binds = true,


    --####  VISUAL SETTINGS

    --osd when navigating in seconds
    osd_duration_seconds = 3,

    --amount of entries to show before slicing. Optimal value depends on font/video size etc.
    showamount = 13,

    --set title of window with stripped name
    set_title_stripped = false,
    title_prefix = "",
    title_suffix = " - mpv",

    --slice long filenames, and how many chars to show
    slice_longfilenames = false,
    slice_longfilenames_amount = 79,

    --show playing file in the first line -> Playing: file.mkv
    show_playing_header = true,

    --show cursor position/length meta -> Playlist - 3/6
    show_playlist_meta = true,

    playing_str_prefix = "$$ ",
    playing_str_suffix = " $$",

    cursor_str_prefix = "## ",
    cursor_str_suffix = " ##",

    non_cursor_str_prefix = "   ",
    non_cursor_str_suffix = "   ",

    playlist_sliced_prefix = "...",
    playlist_sliced_suffix = "...",
}

local function unquote(path)
    local function val(x)
        local a = (x >= 65) and 1 or 0
        local b = (x >= 97) and 1 or 0
        return x - 48 - 7 * a - 32 * b
    end

    local function chr(x, y)
        return string.char(val(x) * 16 + val(y))
    end

    local function is_hexdigit(x)
        return (48 <= x and x <= 57)
            or (65 <= x and x <= 70)
            or (97 <= x and x <= 102)
    end

    local str = ""
    local i = 0
    local x

    while i < #path do
        i = i + 1
        x = path:sub(i, i)

        if x == "%" and #path - i > 1 then
            local a = path:sub(i+1, i+1):byte()
            local b = path:sub(i+2, i+2):byte()

            if is_hexdigit(a) and is_hexdigit(b) then
                x = chr(a, b)
                i = i + 2
            end
        end

        str = str .. x
    end

    return str
end

require('mp.options').read_options(settings, "playlistmanager")

local utils = require 'mp.utils'
local msg = require 'mp.msg'

--parse filename parsing json
if(settings.filename_replace~="") then
    settings.filename_replace = utils.parse_json(settings.filename_replace)
else
    settings.filename_replace = false
end

--parse loadfiles json
settings.loadfiles_filetypes = utils.parse_json(settings.loadfiles_filetypes)

--global variables
strippedname = nil
path = nil
directory = nil
filename = nil
pos = 0
plen = 0
cursor = 0

function on_loaded()
    mp.commandv("script-binding", "random/restore")

    filename = mp.get_property("filename")
    path = mp.get_property('path')
    --if not a url then join path with working directory
    if not path:match("^%a%a+:%/%/") then
        path = utils.join_path(mp.get_property('working-directory'), path)
        directory = utils.split_path(path)
    else
        directory = nil
    end

    refresh_globals()

    if settings.sync_cursor_on_load then cursor=pos end

    strippedname = stripfilename(mp.get_property('media-title'))
    if settings.show_playlist_on_fileload == 2 then
        show_playlist()
    elseif settings.show_playlist_on_fileload == 1 then
        mp.commandv('show-text', strippedname)
    end
    if settings.set_title_stripped then mp.set_property("title", settings.title_prefix..strippedname..settings.title_suffix) end

    --if we promised to load files on launch do it
    if promised_load then
        promised_load = false
        playlist()
    end

    if promised_sort then
        promised_sort = false
        sortplaylist(true)
    end

    if promised_sort_watch then
        promised_sort_watch = false
        mp.msg.info("Added files will automatically sorted")
        mp.observe_property('playlist-count', "number", autosort)
    end

end

function on_closed()
    strippedname = nil
    path = nil
    directory = nil
    filename = nil
end

function refresh_globals()
    pos = mp.get_property_number('playlist-pos', 0)
    plen = mp.get_property_number('playlist-count', 0)
end

function escapepath(dir, escapechar)
    return string.gsub(dir, escapechar, '\\'..escapechar)
end

--create file search query with path to search files, extensions in a table, unix as true(windows false)
function create_searchquery(path, extensions, unix)
    local query = ' '
    for i in pairs(extensions) do
        if unix then
            if extensions[i] ~= "" then extensions[i] = "*."..extensions[i] end
            query = query..extensions[i]..' '
        else
            query = query..'"'..path..'*.'..extensions[i]..'" '
        end
    end
    if unix then
        return 'cd "'..escapepath(path, '"')..'";ls -1p'..query..'2>/dev/null'
    else
        return 'dir /b'..query:gsub("/", "\\")
    end
end

--strip a filename based on its extension or protocol according to rules in settings
function stripfilename(pathfile, media_title)
    local ext = pathfile:match("^.+%.(.+)$")
    local protocol = pathfile:match("^(%a%a+)://")
    if not ext then ext = "" end
    local tmp = pathfile
    if settings.filename_replace and not media_title then
        for k,v in ipairs(settings.filename_replace) do
            if ( v['ext'] and (v['ext'][ext] or (ext and not protocol and v['ext']['all'])) )
                or ( v['protocol'] and (v['protocol'][protocol] or (protocol and not ext and v['protocol']['all'])) ) then
                for ruleindex, indexrules in ipairs(v['rules']) do
                    for rule, override in pairs(indexrules) do
                        tmp = tmp:gsub(rule, override)
                    end
                end
            end
        end
    end
    if settings.slice_longfilenames and tmp:len()>settings.slice_longfilenames_amount+5 then
        tmp = tmp:sub(1, settings.slice_longfilenames_amount).." ..."
    end
    return tmp
end

--gets a nicename of playlist entry at 0-based position i
function get_name_from_index(i)
    refresh_globals()
    if plen <= i then
        mp.msg.error("no index in playlist", i, "length", plen)
        return nil
    end

    local name = mp.get_property('playlist/'..i..'/filename')
    return unquote(name)
end

--gets prefixes and suffixes for playlist 0-based index
function get_fixes_by_index(i)
    local prefix, suffix

    if i == pos then
        prefix = settings.playing_str_prefix
        suffix = settings.playing_str_suffix
    elseif i == cursor then
        prefix = settings.cursor_str_prefix
        suffix = settings.cursor_str_suffix
    else
        prefix = settings.non_cursor_str_prefix
        suffix = settings.non_cursor_str_suffix
    end

    return prefix, suffix
end

function show_playlist(duration)
    --update playlist length and position
    refresh_globals()

    --do not display playlist with 0 files
    if plen == 0 then return end

    add_keybinds()

    if cursor > plen then
        cursor = 0
    end

    output = settings.show_playing_header and "Playing: "..(strippedname or "undefined").."\n\n" or ""
    output = settings.show_playlist_meta and output.."Playlist - "..(cursor+1).." / "..plen.."\n" or output

    local start = cursor - math.floor(settings.showamount/2)
    local showall = false
    local showrest = false

    if start < 0 then
        start = 0
    end

    if plen <= settings.showamount then
        start=0
        showall=true
    end

    if start > math.max(plen-settings.showamount-1, 0) then
        start=plen-settings.showamount
        showrest=true
    end

    if start > 0 and not showall then
        output = output..settings.playlist_sliced_prefix.."\n"
    end

    for index = start, start + settings.showamount - 1, 1 do
        if index == plen then
            break
        end

        local prefix, suffix = get_fixes_by_index(index)
        output = output..prefix..get_name_from_index(index)..suffix.."\n"
        if index == start+settings.showamount-1 and not showall and not showrest then
            output = output..settings.playlist_sliced_suffix
        end
    end

    mp.osd_message(output, (tonumber(duration) or settings.osd_duration_seconds))
    keybindstimer:kill()
    keybindstimer:resume()
end

tag=nil
function tagcurrent()
    refresh_globals()
    if plen == 0 then return end
    if not tag then
        tag=cursor
    else
        tag=nil
    end
    show_playlist()
end

function removefile()
    refresh_globals()
    if plen == 0 then return end
    tag = nil
    if cursor==pos then mp.command("script-message unseenplaylist mark true \"playlistmanager avoid conflict when removing file\"") end
    mp.commandv("playlist-remove", cursor)
    if cursor==plen-1 then cursor = cursor - 1 end
    show_playlist()
end

function moveup()
    refresh_globals()
    if plen == 0 then return end
    if cursor~=0 then
        if tag then mp.commandv("playlist-move", cursor,cursor-1) end
        cursor = cursor-1
    else
        if tag then mp.commandv("playlist-move", cursor,plen) end
        cursor = plen-1
    end
    show_playlist()
end

function movedown()
    refresh_globals()
    if plen == 0 then return end
    if cursor ~= plen-1 then
        if tag then mp.commandv("playlist-move", cursor,cursor+2) end
        cursor = cursor + 1
    else
        if tag then mp.commandv("playlist-move", cursor,0) end
        cursor = 0
    end
    show_playlist()
end

function jumptofile()
    mp.commandv("script-binding", "random/save")
    mp.commandv("script-binding", "random/tmp_disable")

    refresh_globals()

    if plen == 0 then return end
    tag = nil

    if cursor < pos then
        for x=1, math.abs(cursor - pos), 1 do
            mp.commandv("playlist-prev", "weak")
        end
    elseif cursor > pos then
        for x=1, math.abs(cursor - pos), 1 do
            mp.commandv("playlist-next", "weak")
        end
    else
        if cursor ~= plen - 1 then
            cursor = cursor + 1
        end

        mp.commandv("playlist-next", "weak")
    end

    if settings.show_playlist_on_fileload == 0 then
        mp.osd_message("")
    end

    remove_keybinds()
end

--Creates a playlist of all files in directory, will keep the order and position
--For exaple, Folder has 12 files, you open the 5th file and run this, the remaining 7 are added behind the 5th file and prior 4 files before it
function playlist(force_dir)
    refresh_globals()
    if not directory and plen > 0 then return end
    remove_keybinds()
    local hasfile = true
    if plen == 0 then
        hasfile = false
        dir = mp.get_property('working-directory')
    else
        dir = directory
    end
    if force_dir then dir = force_dir end

    local query = create_searchquery(dir, settings.loadfiles_filetypes, settings.linux_over_windows)
    local popen, err = io.popen(query)
    if popen then
        local cur = false
        local c, c2 = 0,0
        local filename = mp.get_property("filename")
        for file in popen:lines() do
            if file:sub(-1) ~= "/" then
                local appendstr = "append"
                if not hasfile then
                    cur = true
                    appendstr = "append-play"
                    hasfile = true
                end
                if cur == true then
                    mp.commandv("loadfile", utils.join_path(dir, file), appendstr)
                    msg.info("Appended to playlist: " .. file)
                    c2 = c2 + 1
                elseif file ~= filename then
                    mp.commandv("loadfile", utils.join_path(dir, file), appendstr)
                    msg.info("Prepended to playlist: " .. file)
                    mp.commandv("playlist-move", mp.get_property_number("playlist-count", 1)-1,  c)
                    c = c + 1
                else
                    cur = true
                end
            end
        end
        popen:close()
        if c2 > 0 or c>0 then
            mp.osd_message("Added "..c + c2.." files to playlist")
        else
            mp.osd_message("No additional files found")
        end
        cursor = mp.get_property_number('playlist-pos', 1)
    else
        msg.error("Could not scan for files: "..(err or ""))
    end
    plen = mp.get_property_number('playlist-count', 0)
end

function alphanumsort(a, b)
    local function padnum(d)
        local dec, n = string.match(d, "(%.?)0*(.+)")
        return #dec > 0 and ("%.12f"):format(d) or ("%s%03d%s"):format(dec, #n, n)
    end
    return tostring(a):lower():gsub("%.?%d+",padnum)..("%3d"):format(#b)
    < tostring(b):lower():gsub("%.?%d+",padnum)..("%3d"):format(#a)
end

function dosort(a,b)
    if settings.alphanumsort then
        return alphanumsort(a,b)
    else
        return a < b
    end
end

function sortplaylist(startover)
    local length = mp.get_property_number('playlist-count', 0)
    if length < 2 then return end
    --use insertion sort on playlist to make it easy to order files with playlist-move
    for outer=1, length-1, 1 do
        local outerfile = get_name_from_index(outer)
        local inner = outer - 1
        while inner >= 0 and dosort(outerfile, get_name_from_index(inner)) do
            inner = inner - 1
        end
        inner = inner + 1
        if outer ~= inner then
            mp.commandv('playlist-move', outer, inner)
        end
    end
    cursor = mp.get_property_number('playlist-pos', 0)
    if startover then
        mp.set_property('playlist-pos', 0)
    end
end

function autosort(name, param)
    if param == 0 then return end
    if plen < param then
        refresh_globals()
        sortplaylist()
    end
end

function shuffleplaylist()
    refresh_globals()
    if plen < 2 then return end
    mp.command("playlist-shuffle")
    while pos ~= 0 do
        mp.command("playlist-prev weak")
        refresh_globals()
    end
end

function add_keybinds()
    mp.add_forced_key_binding('k', 'plm_move_up', moveup, "repeatable")
    mp.add_forced_key_binding('j', 'plm_move_down', movedown, "repeatable")
    mp.add_forced_key_binding('i', 'plm_jump_to_file', jumptofile)
    mp.add_forced_key_binding('x', 'plm_remove_file', removefile, "repeatable")
end

function remove_keybinds()
    if settings.dynamic_binds then
        mp.remove_key_binding('plm_move_up')
        mp.remove_key_binding('plm_move_down')
        mp.remove_key_binding('plm_jump_to_file')
        mp.remove_key_binding('plm_remove_file')
    end
end

keybindstimer = mp.add_periodic_timer(settings.osd_duration_seconds, remove_keybinds)
keybindstimer:kill()

if not settings.dynamic_binds then
    add_keybinds()
end

promised_load = false
if settings.loadfiles_on_start then
    local c = mp.get_property_number('playlist-count', 0)
    if c == 1 then
        promised_load = true
    elseif c == 0 then
        playlist()
    end
end

promised_sort_watch = false
if settings.sortplaylist_on_file_add then
    promised_sort_watch = true
end

promised_sort = false
if settings.sortplaylist_on_start then
    promised_sort = true
end

--script message handler
function handlemessage(msg, value, value2)
    if msg == "show" and value == "playlist" then show_playlist(value2) ; return end
    if msg == "show" and value == "filename" and strippedname and value2 then mp.commandv('show-text', strippedname, tonumber(value2)*1000 ) ; return end
    if msg == "show" and value == "filename" and strippedname then mp.commandv('show-text', strippedname ) ; return end
    if msg == "sort" then sortplaylist(value) ; return end
    if msg == "shuffle" then shuffleplaylist() ; return end
    if msg == "loadfiles" then playlist(value) ; return end
end

mp.register_script_message("playlistmanager", handlemessage)

mp.add_key_binding(nil, "sort", sortplaylist)
mp.add_key_binding(nil, "shuffle", shuffleplaylist)
mp.add_key_binding(nil, "load", playlist)
mp.add_key_binding(nil, "show", show_playlist)

mp.register_event("file-loaded", on_loaded)
mp.register_event("end-file", on_closed)

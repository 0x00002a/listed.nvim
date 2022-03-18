
local I = {}


local function dump_list_file(files)
    local out = {}
    for f, v in pairs(files) do
        if v then
            table.insert(out, f)
        end
    end
    return vim.fn.msgpackdump(out)
end

local function new_list(path, files)
    local list = {}
    list._path = path
    list._files = files

    function list:save()
        local dirname = vim.fn.fnamemodify(self._path, ":h")
        if vim.fn.isdirectory(dirname) ~= 1 then
            vim.fn.mkdir(dirname, "p")
        end
        vim.fn.writefile(dump_list_file(self._files), self._path)
    end
    function list:contains_parent_of(p)
        p = vim.fn.fnamemodify(vim.fn.expand(p), ":p")
        for f, v in pairs(self._files) do
            if v and p:find(f, 1, true) == 1 then
                return true
            end
        end
        return false
    end
    local function to_key(path)
        return vim.fn.fnamemodify(vim.fn.expand(path), ":p")
    end
    function list:remove(key)
        self._files[to_key(key)] = nil
    end
    function list:add(key)
        self._files[to_key(key)] = true
    end
    function list:contains(key)
        return self._files[to_key(key)]
    end

    return list
end

function I.open(path)
    path = vim.fn.fnamemodify(vim.fn.expand(path), ":p")
    local files = nil
    if vim.fn.filereadable(path) ~= 1 then
        files = {}
    else
        files = vim.fn.msgpackparse(vim.fn.readfile(path))
    end
    if files == nil then
        print("error: could not parse listing: " .. path)
        return nil
    end
    local keyedfiles = {}
    for _, f in pairs(files) do
        keyedfiles[f] = true
    end
    return new_list(path, keyedfiles)
end


return I

if not Core then Core = {} end
Core.Helpers = {}

Core.Helpers.Table = {}

Core.Helpers.Table.IsSupersetOf = function(set, elements)
    for _, element in ipairs(elements) do
        if not set[element] then
            return false
        end
    end
    return true
end
  
Core.Helpers.Table.UnionWith = function(table, newTable)
    for _, item in ipairs(newTable) do
        -- Check if the item is already in the table
        local exists = false
        for _, existingItem in ipairs(table) do
            if existingItem == item then
                exists = true
                break
            end
        end
        
        -- If item does not exist, insert it
        if not exists then
            table[#table + 1] = item
        end
    end
end

Core.Helpers.Table.Contains = function(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

Core.Helpers.Table.Count = function(table)
    local count = 0
    for _,v in pairs(table) do
        count = count + 1
    end
    return count
end

Core.Helpers.Table.ExceptWith = function(table, value)
    local tableSet = {}
    
    for _, data in ipairs(value) do
        tableSet[data] = true
    end
    
    for key, _ in pairs(table) do
        if tableSet[key] then
            table[key] = nil
        end
    end
end







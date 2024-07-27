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
        if not table[item] then
            table.insert(table, item)
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





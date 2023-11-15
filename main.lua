fennel = require("lib.fennel")
love.graphics.setDefaultFilter("nearest", "nearest", 1)
table.insert(package.loaders, fennel.make_searcher({correlate=true}))
pp = function(x) print(require("lib.fennelview")(x)) end

require("game")

#= require release/i18next-1.6.3

throw "Can't use BWL.i18n without BWL module loaded" unless BWL?

i18n.init()
BWL.t = BWL.translate = i18n.translate

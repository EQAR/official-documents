--
-- Workaround to replace bold/italics by properly styled text in ODT
--
-- based on https://github.com/jzeneto/pandoc-odt-filters/blob/master/util.lua
-- (credits to José de Mattos Neto)
--
-- author:
--   - name: Colin Tück
--   - address: https://github.com/ctueck
-- date: August 2020
-- license: GPL version 3 or later

util = {}

util.putTagsOnContent = function (textContent, startTag, endTag)
  table.insert(textContent, 1, pandoc.RawInline("opendocument", startTag))
  table.insert(textContent, pandoc.RawInline("opendocument", endTag))
  return textContent
end

-- Required escapes.
-- Ampersand ('&') MUST be the first element added to table `escapes`.
local escapes = {}
escapes["&"] = "&amp;"
escapes["<"] = "&lt;"
escapes[">"] = "&gt;"
local escPattern = "([&<>])"
util.escape = function (text)
  text = string.gsub(text, escPattern, function(char)
           return escapes[char]
         end)
  return text
end

local tags = {}
tags.emph = '<text:span text:style-name=\"Emphasis\">'
tags.strong = '<text:span text:style-name=\"Strong_20_Emphasis\">'
tags.spanEnd = '</text:span>'

return {
  {
    Strong = function(text)
      if FORMAT == 'odt' then
        local content = tags.strong .. util.escape(pandoc.utils.stringify(text)) .. tags.spanEnd
        return pandoc.RawInline("opendocument", content)
      end
    end,
    Emph = function(text)
      if FORMAT == 'odt' then
        local content = tags.emph .. util.escape(pandoc.utils.stringify(text)) .. tags.spanEnd
        return pandoc.RawInline("opendocument", content)
      end
    end,
  }
}


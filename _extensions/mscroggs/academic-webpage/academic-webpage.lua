-- academic-webpage.lua
-- Author: Matthew Scroggs

-- Helper Functions

local function addHTMLDeps()
    quarto.doc.add_html_dependency({
    name = 'academic-webpage',
    stylesheets = {'academic-webpage.css', '../../quarto-ext/fontawesome/assets/css/all.min.css', '../../quarto-ext/fontawesome/assets/css/latex-fontsize.css'}
  })
end

local function isEmpty(s)
  return s == '' or s == nil
end

return {

["academic-webpage"] = function(args, kwargs, meta)


  if quarto.doc.is_format("html:js") then
    -- this will only run for HTML documents
    addHTMLDeps()

    local content = "<div class=\"quarto-about-trestles\">\n"
    content = content .. "  <div class=\"about-entity\">\n"
    if not isEmpty(meta["image"]) then
        content = content .. "    <img src=\"" .. pandoc.utils.stringify(meta["image"]) .. "\" class=\"about-image rounded\" style=\"width: 20em;\">\n"
    end
    content = content .. "    <header id=\"title-block-header\" class=\"quarto-title-block default\">\n"

    content = content .. "      <div class=\"quarto-title\">\n"
    content = content .. "        <h1 class=\"title\">" .. pandoc.utils.stringify(meta["name"]) .. " " .. pandoc.utils.stringify(meta["surname"]) .. "</h1>\n"
    content = content .. "      </div>\n"
    content = content .. "    </header>\n"
    content = content .. "    <div class=\"about-links\">\n"

    if not isEmpty(meta["homepage"]) then
       content = content .. "      <a href=\"" .. pandoc.utils.stringify(meta["homepage"]) .. "\" class=\"about-link\"><i class=\"fa-brands fa-internet-explorer\"></i> Homepage</span></a>\n"
    end
    if not isEmpty(meta["orcid"]) then
       content = content .. "      <a href=\"https://orcid.org/" .. pandoc.utils.stringify(meta["orcid"]) .. "\" class=\"about-link\"><i class=\"fa-brands fa-orcid\"></i> ORCiD</span></a>\n"
    end
    if not isEmpty(meta["github"]) then
       content = content .. "      <a href=\"https://github.com/" .. pandoc.utils.stringify(meta["github"]) .. "\" class=\"about-link\"><i class=\"fa-brands fa-github\"></i> Github</span></a>\n"
    end
    if not isEmpty(meta["bluesky"]) then
       content = content .. "      <a href=\"https://bsky.app/profile/" .. pandoc.utils.stringify(meta["bluesky"]) .. "\" class=\"about-link\"><i class=\"fa-brands fa-bluesky\"></i> Bluesky</span></a>\n"
    end
    content = content .. "    </div>\n"
    content = content .. "  </div>\n"
    content = content .. "  <div class=\"about-contents\"><main class=\"content\" id=\"quarto-document-content\">\n"

    
    local info = meta["info"]
    for i = 1, #info do
        content = content .. "    <p>" .. pandoc.utils.stringify(info[i]) .. "</p>\n"
    end

    if not isEmpty(meta["interests"]) then
        content = content .. "    <section id=\"interests\" class=\"level2\">\n"
        content = content .. "      <h2 data-anchor-id=\"interests\">Interests</h2>\n"
        content = content .. "      <ul>\n"
        local interests = meta["interests"]
        for i=1, #interests do
            content = content .. "        <li>" .. pandoc.utils.stringify(interests[i]) .. "</li>"
        end
        content = content .. "      </ul>\n"
        content = content .. "    </section>\n"
    end

    if not isEmpty(meta["publications"]) then
        content = content .. "    <section id=\"publications\" class=\"level2\">\n"
        content = content .. "      <h2 data-anchor-id=\"publications\">Publications</h2>\n"
        local publications = meta["publications"]
        for i=1, #publications do
            local p = publications[i]
            content = content .. "      <p>"
            local join = ""
            for j=1, #p["authors"] do
                content = content .. join .. pandoc.utils.stringify(p["authors"][j])
                join = ", "
            end
            content = content .. ". " .. pandoc.utils.stringify(p["title"])
            if not isEmpty(p["year"]) then
                content = content .. " (" .. pandoc.utils.stringify(p["year"]) .. ")"
            end
            if not isEmpty(p["journal"]) then
                content = content .. ", " .. pandoc.utils.stringify(p["journal"])
                if not isEmpty(p["volume"]) then
                    content = content .. " " .. pandoc.utils.stringify(p["volume"])
                    if not isEmpty(p["number"]) then
                        content = content .. "(" .. pandoc.utils.stringify(p["number"]) .. ")"
                    end
                end
            end
            if not isEmpty(p["pagestart"]) then
                content = content .. ", " .. pandoc.utils.stringify(p["pagestart"])
                if not isEmpty(p["pageend"]) then
                    content = content .. "&ndash;" .. pandoc.utils.stringify(p["pageend"])
                end
            end
            if not isEmpty(p["doi"]) then
                local doi = pandoc.utils.stringify(p["doi"])
                content = content .. ", <a href=\"https://dx.doi.org/" .. doi .. "\">" .. doi .. "</a>"
            end
            content = content .. "."
            content = content .. "</p>\n"
        end
        content = content .. "    </section>\n"
    end

    if not isEmpty(meta["education"]) then
        content = content .. "    <section id=\"education\" class=\"level2\">\n"
        content = content .. "      <h2 data-anchor-id=\"education\">Education</h2>\n"
        for i=1, #meta["education"] do
            local e = meta["education"][i]
            content = content .. "      <p style=\"text-align:center\">" .. pandoc.utils.stringify(e["institution"])
            if not isEmpty(e["location"]) then
                content = content .. " | " .. pandoc.utils.stringify(e["location"])
            end
            content = content .. "<br />"
            if not isEmpty(e["degree"]) then
                content = content .. pandoc.utils.stringify(e["degree"])
                if not isEmpty(e["location"]) then
                    content = content .. " | "
                end
            end
            if not isEmpty(e["startdate"]) then
                content = content .. pandoc.utils.stringify(e["startdate"])
                if not isEmpty(e["enddate"]) then
                    content = content .. " &ndash; " .. pandoc.utils.stringify(e["enddate"])
                end
            end
            content = content .. "</p>\n"
        end
        content = content .. "      </ul>\n"
        content = content .. "    </section>\n"
    end
    
    

    content = content .. "  </main></div>\n"
    content = content .. "</div>\n"

    return pandoc.RawInline("html", content)

  else
    return pandoc.Null()
  end

end

}


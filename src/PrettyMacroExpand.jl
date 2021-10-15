module PrettyMacroExpand

using MacroTools: prettify
using JuliaFormatter: format_text
using Markdown: Markdown

export @prettyexpand
export @prettyexpand1
export @prettyexpand_md
export @prettyexpand1_md

macro prettyexpand(exp)
    quote
        print($(prettyexpand(exp)))
    end
end

macro prettyexpand1(exp)
    quote
        print($(prettyexpand1(exp)))
    end
end

function prettyexpand(exp)
    quote
        format_text(
            string(
                prettify(
                    @macroexpand($exp)
                )
            );
            margin = 80
        )
    end
end

function prettyexpand1(exp)
    quote
        format_text(
            string(
                prettify(
                    @macroexpand1($exp)
                )
            );
            margin = 80
        )
    end
end

macro prettyexpand_md(exp)
    quote
        Markdown.parse(
            """
            ```julia
            $($(prettyexpand(exp)))
            ```
            """
        )
    end
end

macro prettyexpand1_md(exp)
    quote
        Markdown.parse(
            """
            ```julia
            $($(prettyexpand1(exp)))
            ```
            """
        )
    end
end

end

module PrettyMacroExpand

using MacroTools: prettify
using JuliaFormatter: format_text
using Markdown: Markdown

export @prettyexpand
export @prettyexpand1
export @prettyexpand_md
export @prettyexpand1_md

const alias = Ref(true)
const margin = Ref(80)

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
                    @macroexpand($exp),
                    alias = alias[],
                )
            );
            margin = margin[]
        )
    end
end

function prettyexpand1(exp)
    quote
        format_text(
            string(
                prettify(
                    @macroexpand1($exp),
                    alias = alias[],
                )
            );
            margin = margin[]
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

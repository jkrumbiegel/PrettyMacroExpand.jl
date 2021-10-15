# PrettyMacroExpand

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jkrumbiegel.github.io/PrettyMacroExpand.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jkrumbiegel.github.io/PrettyMacroExpand.jl/dev)
[![Build Status](https://github.com/jkrumbiegel/PrettyMacroExpand.jl/workflows/CI/badge.svg)](https://github.com/jkrumbiegel/PrettyMacroExpand.jl/actions)


PrettyMacroExpand has macros that expand other macros to more readable code using JuliaFormatter and MacroTools.prettify.

There are four macros, `@prettyexpand`, `@prettyexpand1`, `@prettyexpand_md` and `@prettyexpand1_md`. The `1` versions correspond to `@macroexpand1` and only expand the first macro layer, the `md` versions return markdown objects which leads to nicer code formatting, e.g. in Documenter blocks.

Here is an example where we're using the macro on itself:

```julia
julia> @prettyexpand1 @prettyexpand x + 1
PrettyMacroExpand.print(
    PrettyMacroExpand.format_text(
        PrettyMacroExpand.string(
            PrettyMacroExpand.prettify(@macroexpand(x + 1)),
        );
        margin = 80,
    ),
)

julia> @prettyexpand @prettyexpand x + 1
PrettyMacroExpand.print(
    PrettyMacroExpand.format_text(
        PrettyMacroExpand.string(
            PrettyMacroExpand.prettify(
                Base.macroexpand(
                    Main,
                    $(QuoteNode(:(x + 1))),
                    recursive = true,
                ),
            ),
        );
        margin = 80,
    ),
)

julia> @macroexpand @prettyexpand x + 1
quote
    #= /Users/a_user/.julia/dev/PrettyMacroExpand/src/PrettyMacroExpand.jl:12 =#
    PrettyMacroExpand.print(begin
            #= /Users/a_user/.julia/dev/PrettyMacroExpand/src/PrettyMacroExpand.jl:18 =#
            PrettyMacroExpand.format_text(PrettyMacroExpand.string(PrettyMacroExpand.prettify(Base.macroexpand(Main, $(QuoteNode(:(x + 1))), recursive = true))); margin = 80)
        end)
end
```
# PrettyMacroExpand

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jkrumbiegel.github.io/PrettyMacroExpand.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jkrumbiegel.github.io/PrettyMacroExpand.jl/dev)
[![Build Status](https://github.com/jkrumbiegel/PrettyMacroExpand.jl/workflows/CI/badge.svg)](https://github.com/jkrumbiegel/PrettyMacroExpand.jl/actions)


PrettyMacroExpand has macros that expand other macros to more readable code using JuliaFormatter and MacroTools.prettify.

There are four macros, `@prettyexpand`, `@prettyexpand1`, `@prettyexpand_md` and `@prettyexpand1_md`. The `1` versions correspond to `@macroexpand1` and only expand the first macro layer, the `md` versions return markdown objects which leads to nicer code formatting, e.g. in Documenter blocks.

Here is an example using `@prettyexpand1` on itself compared to `@macroexpand1`:

```julia
julia> PrettyMacroExpand.@prettyexpand1 @prettyexpand1 x + y
PrettyMacroExpand.print(
    PrettyMacroExpand.format_text(
        PrettyMacroExpand.string(
            PrettyMacroExpand.prettify(
                @macroexpand1(x + y),
                alias = PrettyMacroExpand.alias[],
            ),
        );
        margin = PrettyMacroExpand.margin[],
    ),
)

julia> @macroexpand1 @prettyexpand1 x + y
quote
    #= /Users/username/.julia/dev/PrettyMacroExpand/src/PrettyMacroExpand.jl:20 =#
    PrettyMacroExpand.print(begin
            #= /Users/username/.julia/dev/PrettyMacroExpand/src/PrettyMacroExpand.jl:43 =#
            PrettyMacroExpand.format_text(PrettyMacroExpand.string(PrettyMacroExpand.prettify(#= /Users/username/.julia/dev/PrettyMacroExpand/src/PrettyMacroExpand.jl:46 =# @macroexpand1(x + y), alias = PrettyMacroExpand.alias[])); margin = PrettyMacroExpand.margin[])
        end)
end
```

You can change the preferred code width with `PrettyMacroExpand.margin[] = 70` and turn of animal name aliasing of temporary variables with `PrettyMacroExpand.alias[] = false`.

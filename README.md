# PrettyMacroExpand

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jkrumbiegel.github.io/PrettyMacroExpand.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jkrumbiegel.github.io/PrettyMacroExpand.jl/dev)
[![Build Status](https://github.com/jkrumbiegel/PrettyMacroExpand.jl/workflows/CI/badge.svg)](https://github.com/jkrumbiegel/PrettyMacroExpand.jl/actions)


PrettyMacroExpand has macros that expand other macros to more readable code using JuliaFormatter and MacroTools.prettify.

There are four macros, `@prettyexpand`, `@prettyexpand1`, `@prettyexpand_md` and `@prettyexpand1_md`. The `1` versions correspond to `@macroexpand1` and only expand the first macro layer, the `md` versions return markdown objects which leads to nicer code formatting, e.g. in Documenter blocks.

Here is an example where we're using the macros on `@prettyexpand` itself:

```julia
julia> @prettyexpand @show x + 1
begin
    Base.println("x + 1 = ", Base.repr(local sheep = x + 1))
    sheep
end

julia> @macroexpand @show x + 1
quote
    Base.println("x + 1 = ", Base.repr(begin
                #= show.jl:955 =#
                local var"#4#value" = x + 1
            end))
    var"#4#value"
end
```
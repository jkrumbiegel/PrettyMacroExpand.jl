using PrettyMacroExpand
using Documenter

DocMeta.setdocmeta!(PrettyMacroExpand, :DocTestSetup, :(using PrettyMacroExpand); recursive=true)

makedocs(;
    modules=[PrettyMacroExpand],
    authors="Julius Krumbiegel <julius.krumbiegel@gmail.com> and contributors",
    repo="https://github.com/jkrumbiegel/PrettyMacroExpand.jl/blob/{commit}{path}#{line}",
    sitename="PrettyMacroExpand.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jkrumbiegel.github.io/PrettyMacroExpand.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jkrumbiegel/PrettyMacroExpand.jl",
    devbranch="main",
)

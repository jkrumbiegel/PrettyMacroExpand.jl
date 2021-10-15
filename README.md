# PrettyMacroExpand

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jkrumbiegel.github.io/PrettyMacroExpand.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jkrumbiegel.github.io/PrettyMacroExpand.jl/dev)
[![Build Status](https://github.com/jkrumbiegel/PrettyMacroExpand.jl/workflows/CI/badge.svg)](https://github.com/jkrumbiegel/PrettyMacroExpand.jl/actions)


PrettyMacroExpand has macros that expand other macros to more readable code using JuliaFormatter and MacroTools.prettify.

There are four macros, `@prettyexpand`, `@prettyexpand1`, `@prettyexpand_md` and `@prettyexpand1_md`. The `1` versions correspond to `@macroexpand1` and only expand the first macro layer, the `md` versions return markdown objects which leads to nicer code formatting, e.g. in Documenter blocks.

Here is an example where we're using the macros to understand what `Threads.@threads` outputs. (All the animal names are local variables that `MacroTools.prettify` rewrites so they are easier to visually parse.)

Here's `@macroexpand1`:

```julia
julia> @macroexpand1 Threads.@threads for i in 1:10
           print("hi")
       end
quote
    #= threadingconstructs.jl:45 =#
    local var"#52#threadsfor_fun"
    #= threadingconstructs.jl:46 =#
    let var"#51#range" = 1:10
        #= threadingconstructs.jl:47 =#
        function var"#52#threadsfor_fun"(var"#64#onethread" = false)
            #= threadingconstructs.jl:47 =#
            #= threadingconstructs.jl:48 =#
            var"#56#r" = var"#51#range"
            #= threadingconstructs.jl:49 =#
            var"#57#lenr" = Base.Threads.length(var"#56#r")
            #= threadingconstructs.jl:51 =#
            if var"#64#onethread"
                #= threadingconstructs.jl:52 =#
                var"#58#tid" = 1
                #= threadingconstructs.jl:53 =#
                (var"#59#len", var"#60#rem") = (var"#57#lenr", 0)
            else
                #= threadingconstructs.jl:55 =#
                var"#58#tid" = Base.Threads.threadid()
                #= threadingconstructs.jl:56 =#
                (var"#59#len", var"#60#rem") = Base.Threads.divrem(var"#57#lenr", Base.Threads.nthreads())
            end
            #= threadingconstructs.jl:59 =#
            if var"#59#len" == 0
                #= threadingconstructs.jl:60 =#
                if var"#58#tid" > var"#60#rem"
                    #= threadingconstructs.jl:61 =#
                    return
                end
                #= threadingconstructs.jl:63 =#
                (var"#59#len", var"#60#rem") = (1, 0)
            end
            #= threadingconstructs.jl:66 =#
            var"#61#f" = Base.Threads.firstindex(var"#56#r") + (var"#58#tid" - 1) * var"#59#len"
            #= threadingconstructs.jl:67 =#
            var"#62#l" = (var"#61#f" + var"#59#len") - 1
            #= threadingconstructs.jl:69 =#
            if var"#60#rem" > 0
                #= threadingconstructs.jl:70 =#
                if var"#58#tid" <= var"#60#rem"
                    #= threadingconstructs.jl:71 =#
                    var"#61#f" = var"#61#f" + (var"#58#tid" - 1)
                    #= threadingconstructs.jl:72 =#
                    var"#62#l" = var"#62#l" + var"#58#tid"
                else
                    #= threadingconstructs.jl:74 =#
                    var"#61#f" = var"#61#f" + var"#60#rem"
                    #= threadingconstructs.jl:75 =#
                    var"#62#l" = var"#62#l" + var"#60#rem"
                end
            end
            #= threadingconstructs.jl:79 =#
            for var"#63#i" = var"#61#f":var"#62#l"
                #= threadingconstructs.jl:80 =#
                local i = #= threadingconstructs.jl:80 =# @inbounds(r[i])
                #= threadingconstructs.jl:81 =#
                begin
                    #= REPL[42]:2 =#
                    print("hi")
                end
            end
        end
    end
    #= threadingconstructs.jl:85 =#
    if Base.Threads.threadid() != 1 || ccall(:jl_in_threaded_region, Base.Threads.Cint, ()) != 0
        #= threadingconstructs.jl:86 =#
        (Base.Threads.Base).invokelatest(var"#52#threadsfor_fun", true)
    else
        #= threadingconstructs.jl:93 =#
        Base.Threads.threading_run(var"#52#threadsfor_fun")
    end
    #= threadingconstructs.jl:95 =#
    Base.Threads.nothing
end
```

Here's `@prettyexpand1` where aliasing of anonymous variables with animal names is enabled:

```julia
julia> @prettyexpand1 Threads.@threads for i in 1:10
           print("hi")
       end
begin
    local sheep
    let alligator = 1:10
        function sheep(pig = false)
            finch = alligator
            curlew = Base.Threads.length(finch)
            if pig
                dinosaur = 1
                (hamster, donkey) = (curlew, 0)
            else
                dinosaur = Base.Threads.threadid()
                (hamster, donkey) =
                    Base.Threads.divrem(curlew, Base.Threads.nthreads())
            end
            if hamster == 0
                if dinosaur > donkey
                    return
                end
                (hamster, donkey) = (1, 0)
            end
            sanddollar =
                Base.Threads.firstindex(finch) + (dinosaur - 1) * hamster
            spider = (sanddollar + hamster) - 1
            if donkey > 0
                if dinosaur <= donkey
                    sanddollar = sanddollar + (dinosaur - 1)
                    spider = spider + dinosaur
                else
                    sanddollar = sanddollar + donkey
                    spider = spider + donkey
                end
            end
            for penguin = sanddollar:spider
                local i = @inbounds(r[i])
                print("hi")
            end
        end
    end
    if Base.Threads.threadid() != 1 ||
       ccall(:jl_in_threaded_region, Base.Threads.Cint, ()) != 0
        (Base.Threads.Base).invokelatest(sheep, true)
    else
        Base.Threads.threading_run(sheep)
    end
    Base.Threads.nothing
end
```

And here it is with aliasing disabled:

```julia
julia> PrettyMacroExpand.alias[] = false
false

julia> PrettyMacroExpand.@prettyexpand1 Threads.@threads for i in 1:10
           print("hi")
       end
begin
    local var"#80#threadsfor_fun"
    let var"#79#range" = 1:10
        function var"#80#threadsfor_fun"(var"#92#onethread" = false)
            var"#84#r" = var"#79#range"
            var"#85#lenr" = Base.Threads.length(var"#84#r")
            if var"#92#onethread"
                var"#86#tid" = 1
                (var"#87#len", var"#88#rem") = (var"#85#lenr", 0)
            else
                var"#86#tid" = Base.Threads.threadid()
                (var"#87#len", var"#88#rem") =
                    Base.Threads.divrem(var"#85#lenr", Base.Threads.nthreads())
            end
            if var"#87#len" == 0
                if var"#86#tid" > var"#88#rem"
                    return
                end
                (var"#87#len", var"#88#rem") = (1, 0)
            end
            var"#89#f" =
                Base.Threads.firstindex(var"#84#r") +
                (var"#86#tid" - 1) * var"#87#len"
            var"#90#l" = (var"#89#f" + var"#87#len") - 1
            if var"#88#rem" > 0
                if var"#86#tid" <= var"#88#rem"
                    var"#89#f" = var"#89#f" + (var"#86#tid" - 1)
                    var"#90#l" = var"#90#l" + var"#86#tid"
                else
                    var"#89#f" = var"#89#f" + var"#88#rem"
                    var"#90#l" = var"#90#l" + var"#88#rem"
                end
            end
            for var"#91#i" = var"#89#f":var"#90#l"
                local i = @inbounds(r[i])
                print("hi")
            end
        end
    end
    if Base.Threads.threadid() != 1 ||
       ccall(:jl_in_threaded_region, Base.Threads.Cint, ()) != 0
        (Base.Threads.Base).invokelatest(var"#80#threadsfor_fun", true)
    else
        Base.Threads.threading_run(var"#80#threadsfor_fun")
    end
    Base.Threads.nothing
end
```
package("txiki.js")
    set_kind("binary")

    set_homepage("https://github.com/saghul/txiki.js")
    set_description("A tiny JavaScript runtime")
    set_license("MIT")

    add_urls("https://github.com/saghul/txiki.js.git")

    add_versions("v24.6.0", "19ae6f3b8eb4317d0c5b5fe05034fa11af062c25")

    on_load("linux" , "cross",function (package)
        if not package:has_cincludes("sys/random.h") then
            package:add("patches", "24.6.0", path.join(os.scriptdir(), "patches", "gcc_low_version.patch"), "a462496b8f75cc77818465317159f30e475dc720a746bb321d9c19b917de796d")
        end
    end)

    add_deps("cmake")

    add_deps("libffi")
    add_deps("libcurl")

    on_install("macosx", "windows", "linux", "android", "mingw", "cross", function (package)
        local configs = {}
        if is_plat("cross") then
            table.insert(configs, "-DBUILD_NATIVE=OFF")
        end
        table.insert(configs, "-DUSE_EXTERNAL_FFI=ON")
        import("package.tools.cmake").install(package, configs,{packagedeps = {"libffi","libcurl"}})
        os.trycp(path.join(package:buildir(), "tjs"), package:installdir("bin"))
        package:addenv("PATH", "bin")
    end)

    on_test(function (package)
        os.vrun("tjs --help")
    end)
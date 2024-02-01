cc_library(
    name = "libzstd",
    srcs = [
        ":common_sources",
        ":compress_sources",
        ":decompress_sources",
        ":dictbuilder_sources",
    ],
    hdrs = [
        "lib/zstd.h",
        "lib/zdict.h",
        "lib/zstd_errors.h",
    ],
    strip_include_prefix = "lib",
    linkopts = [
        "-pthread",
    ],
)

cc_binary(
    name = "zstd_cli",
    srcs = glob([
        "programs/*.h",
        "programs/*.c",
    ]),
    copts = [
        "-DXXH_NAMESPACE=ZSTD_",
        "-DZSTD_GZCOMPRESS", "-DZSTD_GZDECOMPRESS"
    ],
    deps = [
        ":libzstd",
        "@zlib",
    ],
)

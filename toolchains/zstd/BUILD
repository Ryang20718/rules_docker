# From https://github.com/bazelbuild/bazel-central-registry/tree/main/modules/zstd

load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library", "cc_test")

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "libzstd",
    srcs = glob([
            "lib/common/*.c",
            "lib/common/*.h",
            "lib/compress/*.c",
            "lib/compress/*.h",
            "lib/decompress/*.c",
            "lib/decompress/*.h",
            "lib/decompress/*.S",
            "lib/dictBuilder/*.c",
            "lib/dictBuilder/*.h",
    ]),
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

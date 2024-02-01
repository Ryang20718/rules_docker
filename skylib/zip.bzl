# Copyright 2017 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Functions for producing the gzip of an artifact."""

def _gzip(ctx, artifact, out, decompress, options, mnemonic):
    """A helper that calls either the compiled zipper, or the gzip tool.

    Args:
       ctx: The context
       artifact: The artifact to zip/unzip
       out: The output file.
       decompress: Whether to decompress (True) or compress (False)
       options: str list, Command-line options.
       mnemonic: A one-word description of the action
    """
    args = ["-f", "-d", artifact.path, "-o", out.path] if decompress else ["-f", artifact.path, "-o", out.path]
    ctx.actions.run(
        executable = ctx.executable._zipper,
        arguments = args,
        inputs = [artifact],
        outputs = [out],
        mnemonic = mnemonic,
        execution_requirements = {
            # This action produces large output files, but doesn't require much CPU to compute.
            # It's not economical to send this to the remote-cache, instead local cache misses
            # should just run gzip again.
            "no-remote-cache": "1",
        },
        tools = ctx.attr._zipper[DefaultInfo].default_runfiles.files,
    )

def gzip(ctx, artifact, options = None):
    """Create an action to compute the gzipped artifact.

    Args:
       ctx: The context
       artifact: The artifact to zip
       options: str list, Command-line options to pass to gzip.

    Returns:
       the gzipped artifact.
    """
    out = ctx.actions.declare_file(artifact.basename + ".zst")
    _gzip(
        ctx = ctx,
        artifact = artifact,
        out = out,
        decompress = False,
        options = options,
        mnemonic = "ZSTD",
    )
    return out

def gunzip(ctx, artifact):
    """Create an action to compute the gunzipped artifact.

    Args:
       ctx: The context
       artifact: The artifact to zip

    Returns:
       the gunzipped artifact.
    """
    out = ctx.actions.declare_file(artifact.basename + ".zst")
    _gzip(
        ctx = ctx,
        artifact = artifact,
        out = out,
        decompress = True,
        options = None,
        mnemonic = "ZSTD",
    )
    return out

tools = {
    "_zipper": attr.label(
        default = Label("@zstd_cli//:zstd_cli"),
        cfg = "host",
        executable = True,
    ),
}

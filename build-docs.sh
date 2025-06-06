#!/usr/bin/env bash

# This script is used to build the documentation on CloudFlare Pages, this is just used for build previews
# A different script with the same name exists on the `docs-site` branch (where pre-built docs live).

set -e
set -x

python3 -V

python3 -m pip install --user uv
python3 -m uv sync --python 3.12 --group docs --frozen
python3 -m uv run python -c 'import docs.plugins.main'

# Adding local symlinks gets nice source locations like
#   pydantic_core/core_schema.py
# instead of
#   .venv/lib/python3.10/site-packages/pydantic_core/core_schema.py
# See also: mkdocs.yml:mkdocstrings:handlers:python:paths: [.]:
ln -s .venv/lib/python*/site-packages/pydantic_core pydantic_core
ln -s .venv/lib/python*/site-packages/pydantic_settings pydantic_settings
ln -s .venv/lib/python*/site-packages/pydantic_extra_types pydantic_extra_types
# Put these at the front of PYTHONPATH (otherwise, symlinked
# entries will still have "Source code in .venv/lib/.../*.py ":
PYTHONPATH="$PWD${PYTHONPATH:+:${PYTHONPATH}}" python3 -m uv run --no-sync mkdocs build

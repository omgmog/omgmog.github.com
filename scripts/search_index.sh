#!/bin/bash
# Builds the search index into _site/pagefind/ (Jekyll keeps it via keep_files). Run from blog/ after Jekyll has built,
# and again when posts change. CI does the same in the deploy workflow.
# The dev container's _site is root-owned, so if it has a `pagefind` binary on its PATH (docker cp one in; the
# prebuilt npm binary needs AVX) it runs there; otherwise npx runs the published binary on the host.
if docker exec blog-jekyll-1 which pagefind >/dev/null 2>&1; then
  exec docker exec blog-jekyll-1 nice -n 19 pagefind --site /site/_site "$@"
fi
exec nice -n 19 npx -y pagefind@1.6.0 --site _site "$@"

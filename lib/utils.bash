#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/overhangio/tutor"
TOOL_NAME="tutor"
TOOL_TEST="tutor --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# By default we simply list the tag names from GitHub releases.
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	# TODO: Adapt the release URL convention for tutor
	# Example URL: https://github.com/overhangio/tutor/releases/download/v18.1.3/tutor-Linux_x86_64
	url="$GH_REPO/releases/download/v$version/$TOOL_NAME-$(uname -s)_$(uname -m)"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url. $TOOL_NAME binaries are available only for Linux x64 and Mac OS x64."
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"
	local tool_cmd
	tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs or 'nightly' only"
	fi

	if [ "$version" == "nightly" ]; then
		(
			cp -r "$ASDF_DOWNLOAD_PATH"/* "$ASDF_INSTALL_PATH"
			cd "$ASDF_INSTALL_PATH"
			python -m venv .venv
			source .venv/bin/activate
			pip install ".[full]" --quiet --require-virtualenv

			echo "contents of $ASDF_INSTALL_PATH/bin"
			chmod +x .venv/bin/tutor
			ln -s "$ASDF_INSTALL_PATH/.venv/bin/tutor" "$install_path/$tool_cmd"

		 	test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable"
			echo "$TOOL_NAME $version installation was successful!"
		) || (
			rm -rf "$install_path"
			fail "An error occurred while installing $TOOL_NAME $version."
		)
	else
		(
			mkdir -p "$install_path"
			cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

			# TODO: Assert tutor executable exists.
			test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

			echo "$TOOL_NAME $version installation was successful!"
		) || (
			rm -rf "$install_path"
			fail "An error occurred while installing $TOOL_NAME $version."
		)
	fi
}

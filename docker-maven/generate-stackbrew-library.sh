#!/usr/local/bin/bash -eux

latest='11'
default_jdk=jdk
declare -A jdk_latest=( ["jdk"]="11" ["ibmjava"]="8" )
variants=( alpine slim )
declare -A variants_latest=( ["alpine"]="8" ["slim"]="11" )

cd "$(dirname "${BASH_SOURCE[0]}")"

url='https://github.com/carlossg/docker-maven.git'

# prints "$2$1$3$1...$N"
join() {
	local sep="$1"; shift
	local out; printf -v out "${sep//%/%%}%s" "$@"
	echo "${out#$sep}"
}

generate-version() {
	local version=$1
	local branch=$2
	local branch_suffix=""

	if [ "$branch" != 'master' ]; then
		branch_suffix="-${branch}"
	fi

	commit="$(git log -1 --format='format:%H' "$branch" -- "$version")"

	mavenVersion="$(grep -m1 'ARG MAVEN_VERSION=' "$version/Dockerfile" | cut -d'=' -f2)"

	versionAliases=()
	while [ "${mavenVersion%[.-]*}" != "$mavenVersion" ]; do
		versionAliases+=( $mavenVersion-$version )
		# tag 3.5, 3.5.4
		if [[ "$version" == *"$default_jdk-$latest" ]]; then
			versionAliases+=( $mavenVersion )
		elif [[ "$version" == *"ibmjava-${jdk_latest[ibmjava]}" ]]; then
			# tag 3-ibmjava, 3.5-ibmjava, 3.5.4-ibmjava
			versionAliases+=( $mavenVersion-${version//-${jdk_latest[ibmjava]}/} )
		fi
		# tag 3.5-alpine, 3.5.4-alpine, 3.5-slim, 3.5.4-slim
		for variant in "${variants[@]}"; do
			if [[ "$version" == "$default_jdk-${variants_latest[$variant]}-$variant" ]]; then
				versionAliases+=( $mavenVersion-$variant )
			elif [[ "$version" == *"-${variants_latest[$variant]}-$variant" ]]; then
				versionAliases+=( $mavenVersion-${version//-${variants_latest[$variant]}/} )
			fi
		done
		mavenVersion="${mavenVersion%[.-]*}"
	done

	# tag full version
	versionAliases+=( $mavenVersion-$version )

	# tag 3, latest
	if [[ "$version" == "$default_jdk-$latest" ]]; then
		versionAliases+=( $mavenVersion latest )
		[ "$branch" = 'master' ] || versionAliases+=( "$branch" )
	elif [[ "$version" == *"-$latest" ]]; then
		# tag 3-ibmjava ibmjava
		versionAliases+=( $mavenVersion-${version//-$latest/} ${version//-$latest/} )
	fi

	# tag alpine, slim
	for variant in "${variants[@]}"; do
		if [[ "$version" == *"${variants_latest[$variant]}-$variant" ]]; then
			if [[ "$version" == "$default_jdk-${variants_latest[$variant]}"* ]]; then
				versionAliases+=( ${version//$default_jdk-${variants_latest[$variant]}-/} )
			else
				versionAliases+=( ${version//-${variants_latest[$variant]}/} )
			fi
		fi
	done

	from="$(awk 'toupper($1) == "FROM" { print $2 }' "$version/Dockerfile")"
	arches="$(bashbrew cat --format '{{- join ", " .TagEntry.Architectures -}}' "$from")"

	echo
	echo "Tags: $(join ', ' "${versionAliases[@]}")"
	echo "Architectures: $arches"
	[ "$branch" = 'master' ] || echo "GitFetch: refs/heads/$branch"
	echo "GitCommit: $commit"
	echo "Directory: $version"
}

echo 'Maintainers: Carlos Sanchez <carlos@apache.org> (@carlossg)'
echo "GitRepo: $url"

versions=( jdk-*/ ibmjava-*/ )
versions=( "${versions[@]%/}" )

for version in "${versions[@]}"; do
	branch=master
	generate-version "$version" "$branch"
done

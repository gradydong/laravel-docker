#!/bin/bash
set -eo pipefail
shopt -s nullglob

echo "exectuing $0..."

# if command starts with an option, prepend nginx
if [ "${1:0:1}" = '-' ]; then
	set -- nginx "$@"
fi


# skip setup if they want an option that stops mysqld
wantHelp=
for arg; do
	case "$arg" in
		-'?'|-h|-t|-T|-V|-v)
			wantHelp=1
			break
			;;
	esac
done

if [[ "$1" = 'nginx' && -z "$wantHelp" ]]; then
    echo
    echo 'Ready for start up.'
    echo
fi

echo "$@"
exec "$@"

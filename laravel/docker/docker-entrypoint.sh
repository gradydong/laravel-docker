#!/bin/sh
set -e

echo "exectuing $0..."

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

# skip setup if they want an option that stops php-fpm
wantHelp=
for arg; do
	case "$arg" in
		-'?'|-h|-t|-i|-m|-v|-g)
			wantHelp=1
			break
			;;
	esac
done

echo "$@"

if [[ "$1" = 'php-fpm' && -z "$wantHelp" ]]; then
    crond
    echo
    echo 'Start crond service.'
    echo

    supervisord -c /etc/supervisord.conf
    echo
    echo 'Start supervisord service.'
    echo

    chown -R www-data:www-data /var/www/html/public /var/www/html/storage /var/www/html/bootstrap/cache
    echo
    echo 'chown for resources and storage and cache.'
    echo
fi

echo "$@"
exec "$@"

<?php
define( 'WP_CACHE', true);
define( 'WP_DEBUG', false );

define( 'DB_NAME', '{{ mysql_dbs.foto2.name }}');
define( 'DB_USER', '{{ mysql_dbs.foto2.user }}');
define( 'DB_PASSWORD', '{{ mysql_dbs.foto2.pass }}');
define( 'DB_HOST', 'mysql-master.ds' );

define( 'DB_CHARSET', 'utf8mb4' );
define( 'DB_COLLATE', '' );

define( 'AUTH_KEY',         '{{ range(1, 9999999999999) | random | string | password_hash('sha512') }}' );
define( 'SECURE_AUTH_KEY',  '{{ range(1, 9999999999999) | random | string | password_hash('sha512') }}' );
define( 'LOGGED_IN_KEY',    '{{ range(1, 9999999999999) | random | string | password_hash('sha512') }}' );
define( 'NONCE_KEY',        '{{ range(1, 9999999999999) | random | string | password_hash('sha512') }}' );
define( 'AUTH_SALT',        '{{ range(1, 9999999999999) | random | string | password_hash('sha512') }}' );
define( 'SECURE_AUTH_SALT', '{{ range(1, 9999999999999) | random | string | password_hash('sha512') }}' );
define( 'LOGGED_IN_SALT',   '{{ range(1, 9999999999999) | random | string | password_hash('sha512') }}' );
define( 'NONCE_SALT',       '{{ range(1, 9999999999999) | random | string | password_hash('sha512') }}' );

$table_prefix = 'w7c598n7fc948enx_';

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';

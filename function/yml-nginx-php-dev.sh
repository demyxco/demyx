# Demyx
# https://demyx.sh

if [[ "$DEMYX_APP_SSL" = true ]]; then
    DEMYX_YML_NGINX_PHP_LABEL_HTTP='- "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-http.rule='"$DEMYX_YML_HOST_RULE"'"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-http.entrypoints=http"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-http.service=${DEMYX_APP_COMPOSE_PROJECT}-http-port"
      - "traefik.http.services.${DEMYX_APP_COMPOSE_PROJECT}-http-port.loadbalancer.server.port=80"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-http.middlewares=${DEMYX_APP_COMPOSE_PROJECT}-redirect"
      - "traefik.http.middlewares.${DEMYX_APP_COMPOSE_PROJECT}-redirect.redirectregex.regex=^https?:\/\/(?:www\\.)?(.+)"
      - "traefik.http.middlewares.${DEMYX_APP_COMPOSE_PROJECT}-redirect.redirectregex.replacement=https://'"$DEMYX_YML_REGEX"'$${1}"
      - "traefik.http.middlewares.${DEMYX_APP_COMPOSE_PROJECT}-redirect.redirectregex.permanent=true"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-https.rule='"$DEMYX_YML_HOST_RULE"'"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-https.entrypoints=https"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-https.tls.certresolver='$(demyx_certificate_challenge)'"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-https.service=${DEMYX_APP_COMPOSE_PROJECT}-https-port"
      - "traefik.http.services.${DEMYX_APP_COMPOSE_PROJECT}-https-port.loadbalancer.server.port=80"'
    DEMYX_YML_NGINX_PHP_LABEL_CS='- "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-cs.entrypoints=https"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-cs.tls.certresolver='$(demyx_certificate_challenge)'"'
    DEMYX_YML_NGINX_PHP_LABEL_BS='- "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-bs.entrypoints=https"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-bs.tls.certresolver='$(demyx_certificate_challenge)'"'
    DEMYX_YML_NGINX_PHP_LABEL_SOCKET='- "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-socket.entrypoints=https"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-socket.tls.certresolver='$(demyx_certificate_challenge)'"'
    DEMYX_YML_NGINX_PHP_LABEL_AUTH_PROTO=https
else
    DEMYX_YML_NGINX_PHP_LABEL_HTTP='- "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-http.rule='"$DEMYX_YML_HOST_RULE"'"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-http.entrypoints=http"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-http.service=${DEMYX_APP_COMPOSE_PROJECT}-http-port"
      - "traefik.http.services.${DEMYX_APP_COMPOSE_PROJECT}-http-port.loadbalancer.server.port=80"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-http.middlewares=${DEMYX_APP_COMPOSE_PROJECT}-redirect"
      - "traefik.http.middlewares.${DEMYX_APP_COMPOSE_PROJECT}-redirect.redirectregex.regex=^https?:\/\/(?:www\\.)?(.+)"
      - "traefik.http.middlewares.${DEMYX_APP_COMPOSE_PROJECT}-redirect.redirectregex.replacement=http://'"$DEMYX_YML_REGEX"'$${1}"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-https.rule='"$DEMYX_YML_HOST_RULE"'"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-https.entrypoints=https"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-https.tls.certresolver='$(demyx_certificate_challenge)'"
      - "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-https.service=${DEMYX_APP_COMPOSE_PROJECT}-https-port"
      - "traefik.http.services.${DEMYX_APP_COMPOSE_PROJECT}-https-port.loadbalancer.server.port=80"'
    DEMYX_YML_NGINX_PHP_LABEL_CS='- "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-cs.entrypoints=http"'
    DEMYX_YML_NGINX_PHP_LABEL_BS='- "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-bs.entrypoints=http"'
    DEMYX_YML_NGINX_PHP_LABEL_SOCKET='- "traefik.http.routers.${DEMYX_APP_COMPOSE_PROJECT}-socket.entrypoints=http"'
    DEMYX_YML_NGINX_PHP_LABEL_AUTH_PROTO=http
fi

if [[ "$DEMYX_APP_AUTH" = true || -n "$DEMYX_RUN_AUTH" ]]; then
    DEMYX_YML_NGINX_PHP_LABEL_AUTH="- \"traefik.http.routers.\${DEMYX_APP_COMPOSE_PROJECT}-${DEMYX_YML_NGINX_PHP_LABEL_AUTH_PROTO}.middlewares=\${DEMYX_APP_COMPOSE_PROJECT}-auth\"
      - \"traefik.http.middlewares.\${DEMYX_APP_COMPOSE_PROJECT}-auth.basicauth.users=\${DEMYX_APP_AUTH_HTPASSWD}\""
    DEMYX_YML_NGINX_PHP_LABEL_AUTH_BS="- \"traefik.http.routers.\${DEMYX_APP_COMPOSE_PROJECT}-bs.middlewares=\${DEMYX_APP_COMPOSE_PROJECT}-bs-auth\"
      - \"traefik.http.middlewares.\${DEMYX_APP_COMPOSE_PROJECT}-bs-auth.basicauth.users=\${DEMYX_APP_AUTH_HTPASSWD}\""
fi

if [[ "$DEMYX_APP_IP_WHITELIST" != false ]]; then
    DEMYX_YML_WHITELIST="- NGINX_WHITELIST=\${DEMYX_APP_IP_WHITELIST}
      - NGINX_WHITELIST_IP=$DEMYX_IP"
fi

# Refreshing an app while in development loses the value of DEMYX_CONFIG_DEV_BASE_PATH
[[ -z "$DEMYX_CONFIG_DEV_BASE_PATH" ]] && DEMYX_CONFIG_DEV_BASE_PATH=/demyx

echo "# AUTO GENERATED
networks:
  demyx:
    name: demyx
services:
  bs_${DEMYX_APP_ID}:
    cpus: \${DEMYX_APP_WP_CPU}
    depends_on:
      - db_${DEMYX_APP_ID}
    environment:
      - BROWSERSYNC_DOMAIN_MATCH=${DEMYX_APP_DOMAIN}
      - BROWSERSYNC_DOMAIN_RETURN=${DEMYX_APP_DOMAIN}
      - BROWSERSYNC_DOMAIN_SOCKET=${DEMYX_APP_DOMAIN}
      - BROWSERSYNC_PROXY=${DEMYX_APP_COMPOSE_PROJECT}_nx_${DEMYX_APP_ID}_1
      - BROWSERSYNC_FILES=$DEMYX_BS_FILES
      - BROWSERSYNC_PATH=$DEMYX_CONFIG_DEV_BASE_PATH
      - TZ=$TZ
    image: demyx/browsersync
    labels:
      - \"traefik.enable=true\"
      - \"traefik.http.routers.\${DEMYX_APP_COMPOSE_PROJECT}-bs.rule=(Host(\`\${DEMYX_APP_DOMAIN}\`) && PathPrefix(\`${DEMYX_CONFIG_DEV_BASE_PATH}/bs/\`))\"
      - \"traefik.http.routers.\${DEMYX_APP_COMPOSE_PROJECT}-bs.middlewares=\${DEMYX_APP_COMPOSE_PROJECT}-bs-prefix\"
      - \"traefik.http.middlewares.\${DEMYX_APP_COMPOSE_PROJECT}-bs-prefix.stripprefix.prefixes=${DEMYX_CONFIG_DEV_BASE_PATH}/bs/\"
      - \"traefik.http.routers.\${DEMYX_APP_COMPOSE_PROJECT}-bs.service=\${DEMYX_APP_COMPOSE_PROJECT}-bs\"
      - \"traefik.http.services.\${DEMYX_APP_COMPOSE_PROJECT}-bs.loadbalancer.server.port=3000\"
      $DEMYX_YML_NGINX_PHP_LABEL_BS
      - \"traefik.http.routers.\${DEMYX_APP_COMPOSE_PROJECT}-bs.priority=99\"
      - \"traefik.http.routers.\${DEMYX_APP_COMPOSE_PROJECT}-socket.rule=(Host(\`\${DEMYX_APP_DOMAIN}\`) && PathPrefix(\`/browser-sync/socket.io/\`))\"
      - \"traefik.http.middlewares.\${DEMYX_APP_COMPOSE_PROJECT}-socket-prefix.stripprefix.prefixes=${DEMYX_CONFIG_DEV_BASE_PATH}/bs/browser-sync/socket.io/\"
      - \"traefik.http.routers.\${DEMYX_APP_COMPOSE_PROJECT}-socket.service=\${DEMYX_APP_COMPOSE_PROJECT}-socket\"
      - \"traefik.http.services.\${DEMYX_APP_COMPOSE_PROJECT}-socket.loadbalancer.server.port=3000\"
      $DEMYX_YML_NGINX_PHP_LABEL_SOCKET
      - \"traefik.http.routers.\${DEMYX_APP_COMPOSE_PROJECT}-socket.priority=99\"
      ${DEMYX_YML_NGINX_PHP_LABEL_AUTH_BS:-}
    mem_limit: \${DEMYX_APP_WP_MEM}
    networks:
      - demyx
    restart: unless-stopped
    volumes:
      - wp_${DEMYX_APP_ID}:/demyx
  db_${DEMYX_APP_ID}:
    cpus: \${DEMYX_APP_DB_CPU}
    environment:
      - MARIADB_DOMAIN=\${DEMYX_APP_DOMAIN}
      - MARIADB_DATABASE=\${WORDPRESS_DB_NAME}
      - MARIADB_USERNAME=\${WORDPRESS_DB_USER}
      - MARIADB_PASSWORD=\${WORDPRESS_DB_PASSWORD}
      - MARIADB_ROOT_PASSWORD=\${MARIADB_ROOT_PASSWORD}
      - MARIADB_DEFAULT_CHARACTER_SET=\${MARIADB_DEFAULT_CHARACTER_SET}
      - MARIADB_CHARACTER_SET_SERVER=\${MARIADB_CHARACTER_SET_SERVER}
      - MARIADB_COLLATION_SERVER=\${MARIADB_COLLATION_SERVER}
      - MARIADB_KEY_BUFFER_SIZE=\${MARIADB_KEY_BUFFER_SIZE}
      - MARIADB_MAX_ALLOWED_PACKET=\${MARIADB_MAX_ALLOWED_PACKET}
      - MARIADB_TABLE_OPEN_CACHE=\${MARIADB_TABLE_OPEN_CACHE}
      - MARIADB_SORT_BUFFER_SIZE=\${MARIADB_SORT_BUFFER_SIZE}
      - MARIADB_NET_BUFFER_SIZE=\${MARIADB_NET_BUFFER_SIZE}
      - MARIADB_READ_BUFFER_SIZE=\${MARIADB_READ_BUFFER_SIZE}
      - MARIADB_READ_RND_BUFFER_SIZE=\${MARIADB_READ_RND_BUFFER_SIZE}
      - MARIADB_MYISAM_SORT_BUFFER_SIZE=\${MARIADB_MYISAM_SORT_BUFFER_SIZE}
      - MARIADB_SERVER_ID=\${MARIADB_SERVER_ID}
      - MARIADB_INNODB_DATA_FILE_PATH=\${MARIADB_INNODB_DATA_FILE_PATH}
      - MARIADB_INNODB_BUFFER_POOL_SIZE=\${MARIADB_INNODB_BUFFER_POOL_SIZE}
      - MARIADB_INNODB_LOG_FILE_SIZE=\${MARIADB_INNODB_LOG_FILE_SIZE}
      - MARIADB_INNODB_LOG_BUFFER_SIZE=\${MARIADB_INNODB_LOG_BUFFER_SIZE}
      - MARIADB_INNODB_FLUSH_LOG_AT_TRX_COMMIT=\${MARIADB_INNODB_FLUSH_LOG_AT_TRX_COMMIT}
      - MARIADB_INNODB_LOCK_WAIT_TIMEOUT=\${MARIADB_INNODB_LOCK_WAIT_TIMEOUT}
      - MARIADB_INNODB_USE_NATIVE_AIO=\${MARIADB_INNODB_USE_NATIVE_AIO}
      - MARIADB_READ_BUFFER=\${MARIADB_READ_BUFFER}
      - MARIADB_WRITE_BUFFER=\${MARIADB_WRITE_BUFFER}
      - MARIADB_MAX_CONNECTIONS=\${MARIADB_MAX_CONNECTIONS}
      - TZ=$TZ
    image: demyx/mariadb
    mem_limit: \${DEMYX_APP_DB_MEM}
    networks:
      - demyx
    restart: unless-stopped
    volumes:
      - wp_${DEMYX_APP_ID}_db:/demyx
      - wp_${DEMYX_APP_ID}_log:/var/log/demyx
  nx_${DEMYX_APP_ID}:
    cpus: \${DEMYX_APP_WP_CPU}
    depends_on:
      - wp_${DEMYX_APP_ID}
    environment:
      - WORDPRESS=true
      - WORDPRESS_CONTAINER=\${DEMYX_APP_WP_CONTAINER}
      - WORDPRESS_CONTAINER_PORT=9000
      - NGINX_DOMAIN=\${DEMYX_APP_DOMAIN}
      - NGINX_CACHE=false
      - NGINX_UPLOAD_LIMIT=\${DEMYX_APP_UPLOAD_LIMIT}
      - NGINX_RATE_LIMIT=\${DEMYX_APP_RATE_LIMIT}
      - NGINX_XMLRPC=\${DEMYX_APP_XMLRPC}
      - NGINX_BASIC_AUTH=\${DEMYX_APP_AUTH_WP}
      - NGINX_BASIC_AUTH_HTPASSWD=\${DEMYX_APP_AUTH_HTPASSWD}
      - TZ=$TZ
      $DEMYX_YML_WHITELIST
    image: demyx/nginx
    labels:
      - \"traefik.enable=true\"
      $DEMYX_YML_NGINX_PHP_LABEL_HTTP
      ${DEMYX_YML_NGINX_PHP_LABEL_AUTH:-}
    mem_limit: \${DEMYX_APP_WP_MEM}
    networks:
      - demyx
    restart: unless-stopped
    volumes:
      - wp_${DEMYX_APP_ID}:/demyx
      - wp_${DEMYX_APP_ID}_log:/var/log/demyx
  wp_${DEMYX_APP_ID}:
    cpus: \${DEMYX_APP_WP_CPU}
    depends_on:
      - db_${DEMYX_APP_ID}
    environment:
      - PASSWORD=$(demyx_dev_password)
      - WORDPRESS_DOMAIN=\${DEMYX_APP_DOMAIN}
      - WORDPRESS_UPLOAD_LIMIT=\${DEMYX_APP_UPLOAD_LIMIT}
      - WORDPRESS_PHP_EMERGENCY_RESTART_THRESHOLD=\${DEMYX_APP_PHP_EMERGENCY_RESTART_THRESHOLD}
      - WORDPRESS_PHP_EMERGENCY_RESTART_INTERVAL=\${DEMYX_APP_PHP_EMERGENCY_RESTART_INTERVAL}
      - WORDPRESS_PHP_PROCESS_CONTROL_TIMEOUT=\${DEMYX_APP_PHP_PROCESS_CONTROL_TIMEOUT}
      - WORDPRESS_PHP_MEMORY=\${DEMYX_APP_PHP_MEMORY}
      - WORDPRESS_PHP_MAX_EXECUTION_TIME=\${DEMYX_APP_PHP_MAX_EXECUTION_TIME}
      - WORDPRESS_PHP_OPCACHE=\${DEMYX_APP_PHP_OPCACHE}
      - WORDPRESS_PHP_PM=\${DEMYX_APP_PHP_PM}
      - WORDPRESS_PHP_PM_MAX_CHILDREN=\${DEMYX_APP_PHP_PM_MAX_CHILDREN}
      - WORDPRESS_PHP_PM_START_SERVERS=\${DEMYX_APP_PHP_PM_START_SERVERS}
      - WORDPRESS_PHP_PM_MIN_SPARE_SERVERS=\${DEMYX_APP_PHP_PM_MIN_SPARE_SERVERS}
      - WORDPRESS_PHP_PM_MAX_SPARE_SERVERS=\${DEMYX_APP_PHP_PM_MAX_SPARE_SERVERS}
      - WORDPRESS_PHP_PM_PROCESS_IDLE_TIMEOUT=\${DEMYX_APP_PHP_PM_PROCESS_IDLE_TIMEOUT}
      - WORDPRESS_PHP_PM_MAX_REQUESTS=\${DEMYX_APP_PHP_PM_MAX_REQUESTS}
      - TZ=$TZ
      $DEMYX_YML_RUN_CREDENTIALS
    hostname: \${DEMYX_APP_COMPOSE_PROJECT}
    image: demyx/code-server:wp
    labels:
      - \"traefik.enable=true\"
      - \"traefik.http.routers.\${DEMYX_APP_COMPOSE_PROJECT}-cs.rule=Host(\`\${DEMYX_APP_DOMAIN}\`) && PathPrefix(\`${DEMYX_CONFIG_DEV_BASE_PATH}/cs/\`)\"
      - \"traefik.http.routers.\${DEMYX_APP_COMPOSE_PROJECT}-cs.middlewares=\${DEMYX_APP_COMPOSE_PROJECT}-cs-prefix\"
      - \"traefik.http.middlewares.\${DEMYX_APP_COMPOSE_PROJECT}-cs-prefix.stripprefix.prefixes=${DEMYX_CONFIG_DEV_BASE_PATH}/cs/\"
      - \"traefik.http.routers.\${DEMYX_APP_COMPOSE_PROJECT}-cs.service=\${DEMYX_APP_COMPOSE_PROJECT}-cs-port\"
      - \"traefik.http.services.\${DEMYX_APP_COMPOSE_PROJECT}-cs-port.loadbalancer.server.port=8080\"
      $DEMYX_YML_NGINX_PHP_LABEL_CS
      - \"traefik.http.routers.\${DEMYX_APP_COMPOSE_PROJECT}-cs.priority=99\"
    mem_limit: \${DEMYX_APP_WP_MEM}
    networks:
      - demyx
    restart: unless-stopped
    volumes:
      - wp_${DEMYX_APP_ID}_cs_nginx_php:/home/demyx
      - wp_${DEMYX_APP_ID}:/demyx
      - wp_${DEMYX_APP_ID}_log:/var/log/demyx
version: \"$DEMYX_DOCKER_COMPOSE\"
volumes:
  wp_${DEMYX_APP_ID}:
    name: wp_${DEMYX_APP_ID}
  wp_${DEMYX_APP_ID}_cs_nginx_php:
    name: wp_${DEMYX_APP_ID}_cs_nginx_php
  wp_${DEMYX_APP_ID}_db:
    name: wp_${DEMYX_APP_ID}_db
  wp_${DEMYX_APP_ID}_log:
    name: wp_${DEMYX_APP_ID}_log
" > "$DEMYX_APP_PATH"/docker-compose.yml

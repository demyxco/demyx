# Demyx
# https://demyx.sh

demyx_php() {
    demyx_app_config

    if [[ "$DEMYX_APP_TYPE" = wp ]]; then
        cat > "$DEMYX_APP_CONFIG"/php.ini <<-EOF
            ; AUTO GENERATED

            [PHP]
            engine = On
            short_open_tag = Off
            precision = 14
            output_buffering = 4096
            zlib.output_compression = Off
            implicit_flush = Off
            unserialize_callback_func =
            serialize_precision = -1
            disable_functions = pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wifcontinued,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_get_handler,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,pcntl_async_signals,
            disable_classes =
            zend.enable_gc = On
            expose_php = Off
            max_execution_time = 300
            max_input_vars = 20000
            max_input_time = 600
            memory_limit = 256M
            error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
            display_errors = Off
            display_startup_errors = Off
            log_errors = On
            log_errors_max_len = 1024
            ignore_repeated_errors = Off
            ignore_repeated_source = Off
            report_memleaks = On
            html_errors = On
            variables_order = "GPCS"
            request_order = "GP"
            register_argc_argv = Off
            auto_globals_jit = On
            post_max_size = 128M
            auto_prepend_file =
            auto_append_file =
            default_mimetype = "text/html"
            default_charset = "UTF-8"
            doc_root =
            user_dir =
            enable_dl = Off
            file_uploads = On
            upload_max_filesize = 128M
            max_file_uploads = 20
            allow_url_fopen = On
            allow_url_include = Off
            default_socket_timeout = 60

            [CLI Server]
            cli_server.color = On

            [Date]
            date.timezone = America/Los_Angeles
            [filter]

            [iconv]

            [intl]

            [sqlite3]

            [Pcre]

            [Pdo]

            [Pdo_mysql]
            pdo_mysql.default_socket=

            [Phar]

            [mail function]
            SMTP = localhost
            smtp_port = 25
            mail.add_x_header = On

            [ODBC]
            odbc.allow_persistent = On
            odbc.check_persistent = On
            odbc.max_persistent = -1
            odbc.max_links = -1
            odbc.defaultlrl = 4096
            odbc.defaultbinmode = 1

            [Interbase]
            ibase.allow_persistent = 1
            ibase.max_persistent = -1
            ibase.max_links = -1
            ibase.timestampformat = "%Y-%m-%d %H:%M:%S"
            ibase.dateformat = "%Y-%m-%d"
            ibase.timeformat = "%H:%M:%S"

            [MySQLi]
            mysqli.max_persistent = -1
            mysqli.allow_persistent = On
            mysqli.max_links = -1
            mysqli.default_port = 3306
            mysqli.default_socket =
            mysqli.default_host =
            mysqli.default_user =
            mysqli.default_pw =
            mysqli.reconnect = Off

            [mysqlnd]
            mysqlnd.collect_statistics = On
            mysqlnd.collect_memory_statistics = Off

            [OCI8]

            [PostgreSQL]
            pgsql.allow_persistent = On
            pgsql.auto_reset_persistent = Off
            pgsql.max_persistent = -1
            pgsql.max_links = -1
            pgsql.ignore_notice = 0
            pgsql.log_notice = 0

            [bcmath]
            bcmath.scale = 0

            [browscap]

            [Session]
            session.save_handler = files
            session.use_strict_mode = 0
            session.use_cookies = 1
            session.use_only_cookies = 1
            session.name = PHPSESSID
            session.auto_start = 0
            session.cookie_lifetime = 0
            session.cookie_path = /
            session.cookie_domain =
            session.cookie_httponly =
            session.cookie_samesite =
            session.serialize_handler = php
            session.gc_probability = 0
            session.gc_divisor = 1000
            session.gc_maxlifetime = 1440
            session.referer_check =
            session.cache_limiter = nocache
            session.cache_expire = 180
            session.use_trans_sid = 0
            session.sid_length = 26
            session.trans_sid_tags = "a=href,area=href,frame=src,form="
            session.sid_bits_per_character = 5

            [Assertion]
            zend.assertions = -1

            [COM]

            [mbstring]

            [gd]

            [exif]

            [Tidy]
            tidy.clean_output = Off

            [soap]
            soap.wsdl_cache_enabled=1
            soap.wsdl_cache_dir="/tmp"
            soap.wsdl_cache_ttl=86400
            soap.wsdl_cache_limit = 5

            [sysvshm]

            [ldap]
            ldap.max_links = -1

            [dba]

            [opcache]
            opcache.enable=1
            opcache.enable_cli=1
            opcache.interned_strings_buffer=8
            opcache.max_accelerated_files=10000
            opcache.max_wasted_percentage=10
            opcache.memory_consumption=256
            opcache.save_comments=1
            opcache.revalidate_freq=60
            opcache.validate_timestamps=1
            opcache.consistency_checks=0

            [curl]

            [openssl]
EOF
        sed -i 's/            //' "$DEMYX_APP_CONFIG"/php.ini
    fi
}

version: '2'

services:

  mauticdb:
    image: percona/percona-server:5.7
    container_name: mauticdb
    volumes:
      - mysql_data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=${database_password}
    command:
      --character-set-server=utf8mb4 --collation-server=utf8mb4_general_ci
    networks:
      - mautic-net

  mautic:
    image: mautic/mautic:latest
    container_name: mautic
    links:
      - mauticdb:mysql
    depends_on:
      - mauticdb
    ports:
      - 8080:80
    volumes:
      - mautic_data:/var/www/html
    environment:
      - MAUTIC_DB_HOST=mauticdb
      - MYSQL_PORT_3306_TCP=3306
      - MAUTIC_DB_USER=root
      - MAUTIC_DB_PASSWORD=${database_password}
      - MAUTIC_DB_NAME=mautic
      - MAUTIC_RUN_CRON_JOBS=true
    networks:
      - mautic-net

volumes:
  mysql_data:
    driver: local
  mautic_data:
    driver: local
networks:
  mautic-net:
    driver: bridge
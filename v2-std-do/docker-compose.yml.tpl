version: "2"

services:
  database:
    image: powertic/percona-docker
    container_name: database
    environment:
      MYSQL_ROOT_PASSWORD: ${database_password}
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    restart: always
    networks:
      - mauticnet
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_general_ci --sql-mode=""

  mautic:
    container_name: mautic
    image: mautic/mautic:latest
    volumes:
      - mautic_data:/var/www/html
    environment:
      - MAUTIC_DB_HOST=database
      - MAUTIC_DB_USER=root
      - MAUTIC_DB_PASSWORD=${database_password}
      - MAUTIC_DB_NAME=mautic4
    restart: always
    networks:
      - mauticnet
    ports:
      - "8880:80"

volumes:
  mysql_data:
    driver: local
  mautic_data:
    driver: local
networks:
  mauticnet:
    driver: bridge
#!/usr/bin/env sh

DB_USERNAME="${DB_USERNAME:-postgres}"
DB_PASSWORD="${DB_PASSWORD:-}"

DB_USERNAME=$DB_USERNAME DB_PASSWORD=DB_PASSWORD python3 -m flask --app app.app --debug run
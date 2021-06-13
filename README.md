# Geo API

住所や統計情報を元にした GIS 分析をおこなうための API
## ローカル環境

### セットアップ

```bash
$ docker-compose build --no-cache
$ docker-compose run web rails db:create
$ docker-compose up -d
```

http://localhost:3000 でアクセスして画面が表示されればok

### DB接続

```bash
$ docker-compose exec db /bin/bash -c 'psql "user=postgres password=password dbname=geo"'
```
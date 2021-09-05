# Geo API

<img src="https://user-images.githubusercontent.com/5030713/132123897-7c30de11-c7dc-42a5-9aa2-10ab69ef326e.png" alt="Geo API" width="200px">

住所や統計情報を元にした GIS 分析をおこなうための API。

Rails で構築されている REST API。

## API 仕様書

https://docs.geo.qazsato.com/

## セットアップ

```bash
$ docker-compose build --no-cache
$ docker-compose up -d
```

```bash
$ docker-compose exec api rails db:drop
$ docker-compose exec api rails db:create
$ docker-compose exec api rails db:migrate
$ docker-compose exec api rails db:seed
```

http://localhost:3000 でアクセスして画面が表示されればok

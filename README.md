# music-app

The website and backend is in the `website` folder. The file storage server is in the `filestore` folder.

#### Developing

Set up the local PostgreSQL server:

```bash
$ docker-compose -f db-docker-compose.yml up -d
```

Initialize the database (only needs to be run once):

```bash
$ cd setup
$ npm install
$ npm start
$ cd ..
```

Start the webserver:

```bash
$ cd website
$ npm install
$ npm run dev
```

#### Testing

Docker is used for consistent deployments:

```bash
$ cd website
$ docker build . -t music-app:latest
$ cd ..
$ docker-compose up
```

#### Loading and interacting with PostgreSQL in Docker

With the Docker Compose stack up:

```bash
$ docker exec -it cs348_db_1 psql postgresql://postgres:password@localhost/musicapp

# Should now be in the Postgres CLI
```

We can run a few commands to do some basic queries in the Postgres CLI:

```bash
CREATE DATABASE test;
USE test;
CREATE TABLE user(name TEXT);
SELECT * FROM user;
```

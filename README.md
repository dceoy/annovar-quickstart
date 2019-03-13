annovar-quickstart
==================

Docker-based Quickstart kit for ANNOVAR

Usage
-----

1.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/annovar-quickstart.git
    $ cd annovar-quickstart
    ```

2.  Copy `annovar.tar.gz` into `build/`.

    ```sh
    $ cp /path/to/annovar.tar.gz build/
    ```

3.  Build a Docker image.

    ```sh
    $ docker-compose build --pull
    ```

4.  Download annotation databases into `humandb/`.

    ```sh
    $ docker-compose run --rm annovar --debug --downdb
    ```

5.  Annotate the variants in `ex2.vcf` in `annovar.tar.gz`.

    ```sh
    $ docker-compose run --rm annovar --debug
    ```

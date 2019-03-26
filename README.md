annovar-quickstart
==================

Docker-based ANNOVAR Quickstart Kit for VCF files

Requirements
------------

- Git
- Docker
- Docker Compose

Getting started
---------------

1.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/annovar-quickstart.git
    $ cd annovar-quickstart
    ```

2.  Copy `annovar.tar.gz` into `build/`.

    ```sh
    $ cp /path/to/annovar.tar.gz build/
    ```

3.  Prepare input VCF files.

    The following step uses `ex2.vcf` in `annovar.tar.gz` as an example.

    ```sh
    $ mkdir input
    $ cd input
    $ tar xvf ../build/annovar.latest.tar.gz annovar/example/ex2.vcf
    $ cd -
    ```

4.  Build a Docker image.

    ```sh
    $ docker-compose build --pull
    ```

5.  Download annotation databases into `humandb/`.

    ```sh
    $ docker-compose run --rm annovar --downdb
    ```

6.  Annotate variants in VCF files.

    ```sh
    $ docker-compose run --rm annovar input/annovar/example/ex2.vcf
    ```

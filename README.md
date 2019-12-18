annovar-vcf-cli
===============

ANNOVAR execution kit for VCF files

Getting started
---------------

Requirements:

- Git
- Docker
- Docker Compose

##### Build a Docker image

1.  Download `annovar.tar.gz` from [ANNOVAR's website](http://annovar.openbioinformatics.org/).

2.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/annovar-vcf-cli.git
    $ cd annovar-vcf-cli
    ```

3.  Copy `annovar.tar.gz` into `build/`.

    ```sh
    $ cp /path/to/annovar.tar.gz build/
    ```

4.  Build a Docker image.

    ```sh
    $ docker-compose build --pull
    ```

##### Run ANNOVAR

1.  Prepare input VCF files.

    The following step uses `ex2.vcf` in `annovar.tar.gz` as an example.

    ```sh
    $ mkdir input
    $ cd input
    $ tar xvf ../build/annovar.latest.tar.gz annovar/example/ex2.vcf
    $ cd -
    ```

2.  Download annotation databases into `humandb/`.

    ```sh
    $ docker-compose run --rm annovar --downdb
    ```

3.  Annotate variants in VCF files.

    ```sh
    $ docker-compose run --rm annovar input/annovar/example/ex2.vcf
    ```

Configuration
-------------

- `bin/annovar_cli.sh`
  - Command-line interface controller
- `bin/annovar_db.sh`
  - Database file downloader
    - Wrappers of `annotate_variation.pl` and others.
  - Edit this script to specify the databases to download
- `bin/annovar_vcf.sh`
  - Variant annotator for VCF files
    - Wrapper of `table_annovar.pl`
  - Edit this script to specify the databases to use

Usage
-----

```sh
$ docker-compose run --rm annovar --help
ANNOVAR execution kit for VCF files

Usage:
  annovar_cli.sh [--downdb] [--db-dir=<path>] [--out-dir=<path>]
                 [--thread=<int>] [<vcf>...]
  annovar_cli.sh -h|--help
  annovar_cli.sh --version

Options:
  --downdb          Download database files
  --db-dir=<path>   Set a database directory [default: ./humandb]
  --out-dir=<path>  Set an output directory [default: ./output]
  --thread=<int>    Limit cores for multithreading
  -h, --help        Print usage information
  --version         Print version information

Arguments:
  <vcf>...          Paths to input VCF files
```

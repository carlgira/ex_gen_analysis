# Computational Exome and Genome Analysis - Dockerfile	

Dockerfile with all the tools of the book "Computational Exome and Genome Analysis" - Peter N. Robinson • Rosario M. Piro Marten Jäger.

## How to use

- Install docker
- Clone repo and build the image
```
docker build -t ex_gen_analysis:latest .
```

- Use any of the commands using

```
docker run -it ex_gen_analysis:latest fastqc
```

- Optionally create an alias

```
alias drun="docker run -it ex_gen_analysis:latest"
```

## List of commands

```
drun fastqc -h
drun bwa
drun samtools
drun bcftools
drun bam-readcount
drun java -jar /opt/libs/picard.jar
drun bedtools
drun vcftools
drun gatk
drun java -jar /opt/libs/jannovar-cli.jar
drun delly
drun java -jar /opt/libs/exomiser-cli.jar
drun java -jar /opt/libs/varscan.jar
drun oncotator
drun java -jar /opt/libs/trimmomatic.jar
drun triodenovo
drun cnvnator
drun configManta.py
```
## Notes

- gatk 3.8 it's used on the book but i installed gatk 4.0 and it has changed. To download the old version go to:
https://software.broadinstitute.org/gatk/download/archive
- If you want to use smaller docker images that only contains one of the tools you can check http://biocontainers.pro/



FROM ubuntu:xenial

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y gnupg wget software-properties-common apt-transport-https && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
RUN apt-get update -y
RUN apt-get install -y \
    libz-dev \
    gcc \
    make \
    autoconf \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    maven \
    default-jdk \
    cmake \
    perl \
    ant \
    python2.7 \
    virtualenv \
    git-core \
    python-dev \
    r-base \
    libxpm4

ENV INSTALL_DIR=/opt
RUN ln -sf /usr/bin/python2.7 /usr/local/bin/python2
RUN mkdir -p $INSTALL_DIR/libs

##############################
## fastqc 0.11.7 - 10/01/2018#
##############################

RUN wget -qO- https://github.com/s-andrews/FastQC/archive/v0.11.7.tar.gz | tar -xz -C $INSTALL_DIR && \
    cd $INSTALL_DIR/FastQC-0.11.7 && \
    ant && \
    chmod 755 bin/fastqc && \
    ln -s $INSTALL_DIR/FastQC-0.11.7/bin/fastqc /usr/local/bin/fastqc

###########################
## bwa 0.7.17 - 23/10/2017#
###########################

RUN wget -qO- https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2 | tar -xj -C $INSTALL_DIR && \
    cd $INSTALL_DIR/bwa-0.7.17 && \
    make && \
    ln -s $INSTALL_DIR/bwa-0.7.17/bwa /usr/local/bin/bwa

###########################
## htslib 1.9 - 23/07/2018#
###########################

RUN wget -qO- https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2 | tar -xj -C $INSTALL_DIR && \
    cd $INSTALL_DIR/htslib-1.9 && \
    ./configure  --enable-plugins && \
    make && \
    make install

#############################
## samtools 1.9 - 23/07/2018#
#############################

RUN wget -qO- https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 | tar -xj -C $INSTALL_DIR && \
    cd $INSTALL_DIR/samtools-1.9 && \
    ./configure && \
    make && \
    make install

ENV SAMTOOLS=$INSTALL_DIR/samtools-1.9

#############################
## bcftools 1.9 - 23/07/2018#
#############################

RUN wget -qO- https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 | tar -xj -C $INSTALL_DIR && \
    cd $INSTALL_DIR/bcftools-1.9 && \
    make && \
    make install

####################################
## bam-readcount 0.8.0 - 22/10/2016#
####################################

RUN wget -qO- https://github.com/genome/bam-readcount/archive/v0.8.0.tar.gz | tar -xz -C $INSTALL_DIR  && \
    cd $INSTALL_DIR/bam-readcount-0.8.0 && \
    cmake . && \
    make && \
    make install

###############################
## picard 2.18.11 - 23/07/2018#
###############################

RUN mkdir -p $INSTALL_DIR/picard && \
    wget -q https://github.com/broadinstitute/picard/releases/download/2.18.11/picard.jar -P $INSTALL_DIR/picard && \
    ln -s $INSTALL_DIR/picard/picard.jar $INSTALL_DIR/libs/picard.jar

################################
## bedtools 2.27.1 - 14/12/2017#
################################

RUN wget -qO- https://github.com/arq5x/bedtools2/releases/download/v2.27.1/bedtools-2.27.1.tar.gz | tar -xz -C $INSTALL_DIR && \
    cd $INSTALL_DIR/bedtools2 && \
    make && \
    ln -s $INSTALL_DIR/bedtools2/bin/* /usr/local/bin/

################################
## vcftools 0.1.16 - 02/08/2018#
################################

RUN wget -qO- https://github.com/vcftools/vcftools/releases/download/v0.1.16/vcftools-0.1.16.tar.gz | tar -xz -C $INSTALL_DIR && \
    cd $INSTALL_DIR/vcftools-0.1.16 && \
    ./configure && \
    make && \
    make install

#############################
## gatk 4.0.7.0 - 31/07/2018#
#############################

RUN wget -q https://github.com/broadinstitute/gatk/releases/download/4.0.7.0/gatk-4.0.7.0.zip && \
    unzip gatk-4.0.7.0.zip -d $INSTALL_DIR && \
    rm gatk-4.0.7.0.zip && \
    ln -s $INSTALL_DIR/gatk-4.0.7.0/gatk /usr/local/bin/gatk

##############################
## jannovar 0.25 - 26/04/2018#
##############################

RUN wget -qO- https://github.com/charite/jannovar/archive/v0.25.tar.gz | tar -xz -C $INSTALL_DIR && \
    cd $INSTALL_DIR/jannovar-0.25 && \
    mvn clean package -Dmaven.test.skip=true && \
    ln -s $INSTALL_DIR/jannovar-0.25/jannovar-cli/target/jannovar-cli-0.25.jar $INSTALL_DIR/libs/jannovar-cli.jar

#############################
## delly 0.7.8 -  18/01/2018#
#############################

RUN mkdir -p $INSTALL_DIR/delly && \
    wget -q https://github.com/dellytools/delly/releases/download/v0.7.8/delly_v0.7.8_linux_x86_64bit -P $INSTALL_DIR/delly && \
    chmod 755 $INSTALL_DIR/delly/delly_v0.7.8_linux_x86_64bit && \
    ln -s $INSTALL_DIR/delly/delly_v0.7.8_linux_x86_64bit /usr/local/bin/delly

#############################
## manta 1.4.0 -  24/04/2018#
#############################

RUN wget -qO- https://github.com/Illumina/manta/releases/download/v1.4.0/manta-1.4.0.release_src.tar.bz2 | tar -xj -C $INSTALL_DIR && \
    cd $INSTALL_DIR/manta-1.4.0.release_src && \
    mkdir build && cd build && \
    ../configure --jobs=2 --prefix=../bin && \
    make -j4 install

ENV PATH="${INSTALL_DIR}/manta-1.4.0.release_src/bin/bin:${PATH}"

################################
## exomiser 10.1.0 - 18/05/2018#
################################

RUN wget -q https://data.monarchinitiative.org/exomiser/latest/exomiser-cli-10.1.0-distribution.zip && \
    unzip exomiser-cli-10.1.0-distribution.zip -d $INSTALL_DIR && \
    rm exomiser-cli-10.1.0-distribution.zip && \
    ln -s $INSTALL_DIR/exomiser-cli-10.1.0/exomiser-cli-10.1.0.jar $INSTALL_DIR/libs/exomiser-cli.jar

##############################
## varscan 2.4.3 - 01/12/2016#
##############################

WORKDIR $INSTALL_DIR
RUN git clone https://github.com/dkoboldt/varscan.git && \
    ln -s $INSTALL_DIR/varscan/VarScan.v2.4.3.jar  $INSTALL_DIR/libs/varscan.jar

##############
## R packages# 
##############

RUN echo "install.packages('ggplot2', dep = TRUE)" | R --no-save

################################
## oncotator 2.4.3 - 01/12/2016#
################################

RUN wget -qO- https://github.com/broadinstitute/oncotator/archive/v1.9.9.0.tar.gz | tar -xz -C $INSTALL_DIR && \
    cd $INSTALL_DIR/oncotator-1.9.9.0 && \
    virtualenv env --python=python2 && \
    . env/bin/activate && \
    python setup.py install && \
    ln -s $INSTALL_DIR/oncotator-1.9.9.0/env/bin/oncotator /usr/local/bin/oncotator

##################################
## Trimmomatic 2.4.3 - 10/03/2015#
##################################

RUN wget -q http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.38.zip && \
    unzip Trimmomatic-0.38.zip -d $INSTALL_DIR && \
    rm Trimmomatic-0.38.zip && \
    ln -s $INSTALL_DIR/Trimmomatic-0.38/trimmomatic-0.38.jar $INSTALL_DIR/libs/trimmomatic.jar

################################
## Triodenovo 0.05 - 20/06/2016#
################################

RUN wget -qO- https://genome.sph.umich.edu/w/images/8/81/Triodenovo.0.05.tar.gz | tar -xz -C $INSTALL_DIR && \
    cd $INSTALL_DIR/triodenovo.0.05 && \
    find . -type f -exec sed -i 's/-Werror//g' {} + && \
    make && \
    ln -s $INSTALL_DIR/triodenovo.0.05/bin/triodenovo /usr/local/bin/triodenovo

#############################
## root 6.08.00 - 04/11/2016#
#############################
# Old release to compile CNVnator

RUN wget -qO- https://root.cern.ch/download/root_v6.08.00.Linux-ubuntu16-x86_64-gcc5.4.tar.gz | tar -xz -C $INSTALL_DIR
RUN cp $INSTALL_DIR/root/lib/*.so /usr/lib/

###############################
## CNVnator 0.3.3 - 28/11/2016#
###############################

ENV ROOTSYS=$INSTALL_DIR/root
RUN wget -q https://github.com/abyzovlab/CNVnator/releases/download/v0.3.3/CNVnator_v0.3.3.zip && \
    unzip CNVnator_v0.3.3.zip -d $INSTALL_DIR && \
    rm CNVnator_v0.3.3.zip && \
    cd $INSTALL_DIR/CNVnator_v0.3.3/src/samtools && \
    make && \
    cd .. && \
    sed -i 's/g++/g++ -lThread -lMatrix -lNet/g' Makefile && \
    make && \
    ln -s $INSTALL_DIR/CNVnator_v0.3.3/src/cnvnator /usr/local/bin/cnvnator

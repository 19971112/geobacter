#PBS -q small
#PBS -l ncpus=1
#PBS -V
cd ${PBS_O_WORKDIR}

# extracting 16S rRNA sequence from GenBank files and concatenate
mkdir -p data/16S_all
for i in data/dataset/*.gbff; do python scripts/ex_16SrRNA.py $i > $i.16S.fasta; mv $i.16S.fasta data/16S_all; done
cat data/16S_all/*.16S.fasta | sed -e 's/data\/dataset\///g' | sed -e 's/,/_/g' | sed -e 's/___/_/g' > data/16S_all/all.fasta

# Multiple alignment
mkdir -p analysis/16S_phylogeny_all
mafft --auto data/16S_all/all.fasta > analysis/16S_phylogeny_all/16S_all.maf

# phylogeny
FastTree -gtr -nt analysis/16S_phylogeny_all/16S_all.maf > analysis/16S_phylogeny_all/16S_all.maf.newick

# rename
python scripts/replace.py data/replacelist/replacelist2.txt analysis/16S_phylogeny_all/16S_all.maf.newick > analysis/16S_phylogeny_all/rename_16S_all.maf.newick

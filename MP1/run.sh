#!/bin/zsh

mkdir -p compiled images

# ############ Convert friendly and compile to openfst ############
for i in friendly/*.txt; do
   python compact2fst.py  $i  > sources/$(basename $i ".formatoAmigo.txt").txt
done


# ############ convert words to openfst ############
for w in tests/*.str; do
	python word2fst.py `cat $w` > tests/$(basename $w ".str").txt
done


# ############ Compile source transducers ############
for i in sources/*.txt tests/*.txt; do
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done

fstcompose compiled/step1.fst compiled/step2.fst > compiled/meta12.fst
fstcompose compiled/meta12.fst compiled/step3.fst > compiled/meta123.fst
fstcompose compiled/meta123.fst compiled/step4.fst > compiled/meta1234.fst
fstcompose compiled/meta1234.fst compiled/step5.fst > compiled/meta12345.fst
fstcompose compiled/meta12345.fst compiled/step6.fst > compiled/meta123456.fst
fstcompose compiled/meta123456.fst compiled/step7.fst > compiled/meta1234567.fst
fstcompose compiled/meta1234567.fst compiled/step8.fst > compiled/meta12345678.fst
fstcompose compiled/meta12345678.fst compiled/step9.fst > compiled/metaphoneLN.fst

rm compiled/meta1*

echo "---------------------------------------- Testing MetaphoneLN ----------------------------------------"

for w in compiled/t-*; do
    echo $w
    fstcompose $w compiled/metaphoneLN.fst  | fstshortestpath  | fstproject --project_type=output |
    fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt 
    printf "\n"
done


for i in compiled/*.fst; do
   fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done

fstinvert compiled/metaphoneLN.fst > compiled/invertMetaphoneLN.fst 

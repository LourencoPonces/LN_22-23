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

<<com
# ############ generate PDFs  ############
#echo "Starting to generate PDFs"
for i in compiled/*.fst; do
	#echo "Creating image: images/$(basename $i '.fst').pdf"
   fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done
com


# ############ tests  ############

echo "---------------------------------------- Testing Step 1 ----------------------------------------"

for w in compiled/t-step1*.fst; do
    fstcompose $w compiled/step1.fst | fstshortestpath | fstproject --project_type=output |
    fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
done

echo "---------------------------------------- Testing Step 2 ----------------------------------------"

for w in compiled/t-step2*.fst; do
    fstcompose $w compiled/step2.fst | fstshortestpath | fstproject --project_type=output |
    fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
done

echo "---------------------------------------- Testing Step 3 ----------------------------------------"

for w in compiled/t-step3*.fst; do
    fstcompose $w compiled/step3.fst | fstshortestpath | fstproject --project_type=output |
    fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
done

echo "---------------------------------------- Testing Step 4 ----------------------------------------"

for w in compiled/t-step4*.fst; do
    fstcompose $w compiled/step4.fst | fstshortestpath | fstproject --project_type=output |
    fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
done

echo "---------------------------------------- Testing Step 5 ----------------------------------------"

for w in compiled/t-step5*.fst; do
    fstcompose $w compiled/step5.fst | fstshortestpath | fstproject --project_type=output |
    fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
done

echo "---------------------------------------- Testing Step 6 ----------------------------------------"

for w in compiled/t-step6*.fst; do
    fstcompose $w compiled/step6.fst | fstshortestpath | fstproject --project_type=output |
    fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
done

echo "---------------------------------------- Testing Step 7 ----------------------------------------"

for w in compiled/t-step7*.fst; do
    fstcompose $w compiled/step7.fst | fstshortestpath | fstproject --project_type=output |
    fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
done

echo "---------------------------------------- Testing Step 8 ----------------------------------------"

for w in compiled/t-step8*.fst; do
    fstcompose $w compiled/step8.fst | fstshortestpath | fstproject --project_type=output |
    fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
done

echo "---------------------------------------- Testing Step 9 ----------------------------------------"

for w in compiled/t-step9*.fst; do
    fstcompose $w compiled/step9.fst | fstshortestpath | fstproject --project_type=output |
    fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
done

fstcompose compiled/step1.fst compiled/step2.fst > compiled/meta12.fst
fstcompose compiled/meta12.fst compiled/step3.fst > compiled/meta123.fst
fstcompose compiled/meta123.fst compiled/step4.fst > compiled/meta1234.fst
fstcompose compiled/meta1234.fst compiled/step5.fst > compiled/meta12345.fst
fstcompose compiled/meta12345.fst compiled/step6.fst > compiled/meta123456.fst
fstcompose compiled/meta123456.fst compiled/step7.fst > compiled/meta1234567.fst
fstcompose compiled/meta1234567.fst compiled/step8.fst > compiled/meta12345678.fst
fstcompose compiled/meta12345678.fst compiled/step9.fst > compiled/metaphoneLN.fst

fstinverted compiled/metaphoneLN.fst > compiled/invertMetaphoneLN.fst 
rm compiled/meta1*

echo "---------------------------------------- Testing MetaphoneLN ----------------------------------------"

for w in compiled/t-*; do
    echo $w
    fstcompose $w compiled/metaphoneLN.fst out/$(basename $w ".fst").fst | fstshortestpath out/$(basename $w ".fst").fst | fstproject --project_type=output |
    fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt #> out/$(basename $w ".fst").txt
    printf "\n"
done

#for w in out/*.txt; do
#    fstcompile --isymbols=syms.txt --osymbols=syms.txt $w | fstarcsort > out/$(basename $w ".txt").fst
#done
#for w in out/*.fst; do
#   fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $w | dot -Tpdf > out/$(basename $w '.fst').pdf
#done

#fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt compiled/metaphoneLN.fst | dot -Tpdf > images/metaphoneLN.pdf
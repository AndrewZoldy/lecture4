
#!/bin/bash
touch output.out
nucleotides=( A T G C )
array=()
chromosomes=$(grep "^chr" sample1.vcf | awk '{print $1}' | uniq)
pairs=()
fullarray=()
for nucl in ${nucleotides[@]}
        do
                for nucl1 in ${nucleotides[@]}
                do
                        if [ ${nucl} = ${nucl1} ]
                        then
                                continue
			else
				pairs+=("${nucl}>${nucl1}")

			fi
		done
	done
fullarray+=( "Chromosome	$(IFS=$'\t';printf '%s\t' ${pairs[@]})	Summary"$'\n')
for chromosome in ${chromosomes}
do
	sum=0
	for pair in ${pairs[@]}
	do
		nucl=${pair:0:1}
		nucl1=${pair:2:1}
		amount=`awk -v chr=$chromosome -v nucl=${nucl} -v nucl1=${nucl1} '($1 == chr) && ($4 == nucl) && ($5 == nucl1) {print}' ./sample1.vcf |wc -l`
		array+=(${amount})
		sum=$(($sum+$amount))
	done
fullarray+=( "${chromosome}	$(IFS=$'\t';printf '%s\t' ${array[@]})	${sum}"$'\n' )
array=()
done

printf '%s\t' "${fullarray[@]}" | sort -g -k14 -b > output.out


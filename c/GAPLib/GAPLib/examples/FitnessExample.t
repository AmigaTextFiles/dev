
/*
 * This is an example template file for the GAP Conjurer. The GAP Conjurer
 * is a source wizard accompanying GAP-Lib.
 *
 * After processing the following substitutions will be made: 
 *
 * $N => Name of the current type of individual. eg. "Polyphant"
 *
 * $I => Index of the current population. eg. "0"
 *
 * $$ => A single dollar sign.
 *
 * There should be no other occurences of dollar signs in the template file.
 *
 *
 * The example fitness function is simply the hamming distance (the number
 * of differing bits) between the genome bitstring and the constant string
 * "\xAA\xAA\xAA\xAA" which has every other bit set and every other clear.
 *
 *
 * The negation is because GAP-Lib sees higher fitness as better, and the
 * 4 is the length of the bitstring.
 *
 */


double $NFitness(struct $N *Polly)
{
double fitness;

fitness = -HammingDist(Polly->Data,"\xAA\xAA\xAA\xAA",4);

return(fitness);
}


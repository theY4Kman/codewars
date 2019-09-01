#include <criterion/criterion.h>

char *dna_strand(const char *dna);

Test(dna_strand, should_return_complementary_dna_sample) {
  cr_assert_str_eq(dna_strand("AAAA"), "TTTT");
  cr_assert_str_eq(dna_strand("ATTGC"), "TAACG");
  cr_assert_str_eq(dna_strand("GTAT"), "CATA");
}

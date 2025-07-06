#include <stdio.h>
#include <stdlib.h>

int main()
{
    printf("Compiled with GCC version: %s\n", __VERSION__);

#ifdef __STDC_VERSION__
    printf("C standard version: %ld\n", __STDC_VERSION__);
#else
    printf("C standard: Pre-C90 or C90\n");
#endif

#ifdef __GNUC__
    printf("GCC major version: %d\n", __GNUC__);
#ifdef __GNUC_MINOR__
    printf("GCC minor version: %d\n", __GNUC_MINOR__);
#endif
#endif

    return 0;
}

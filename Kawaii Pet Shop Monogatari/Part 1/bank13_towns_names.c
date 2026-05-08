#include <stdint.h>
#include <stdio.h>

void b13_towns_names(FILE* fptr) {
    // --- BLOCK 0x13: town names ---
    fseek(fptr, 0x4d54a, SEEK_SET);
    //07 77 9A 7D 5F 52 7D EF FF | くリボンタウン | Taenia/Ribbon Town
    fwrite((uint8_t[]){0x07, 0xb3, 0xa0, 0xa4, 0xad, 0xa8, 0xa0, 0xef, 0xff }, 1, 9, fptr);
    //89 77 CB 7D 5F 52 7D FF | グリ-ンタウン | Verdant/Green Town
    fwrite((uint8_t[]){0xb5, 0xa4, 0xb1, 0xa3, 0xa0, 0xad, 0xb3, 0xff}, 1, 8, fptr);
    //77 86 60 5F 52 7D EF FF | リッチタウン | Aurum/Rich Town
    fwrite((uint8_t[]){0xa0, 0xb4, 0xb1, 0xb4, 0xac, 0xef, 0xef, 0xef, 0xff}, 1, 8, fptr);
    //5C 68 CB 5F 52 7D EF FF | スノ-タウン | Glacia/Snow Town
    fwrite((uint8_t[]){0xa6, 0xab, 0xa0, 0xa2, 0xa8, 0xa0, 0xef, 0xff}, 1, 8, fptr);
    //96 64 64 5F 52 7D EF FF | バナナタウン | Tropica/Banana Town | Arabs, sand, desert in banana town. WTF? | Changed to Ramila
    fwrite((uint8_t[]){0xb1, 0xa0, 0xac, 0xa8, 0xab, 0xa0, 0xef, 0xef, 0xff}, 1, 8, fptr);
    //1E 10 18 0E 13 EF EF FF | まちのそと | Outside/Outside Town/Outskirts
    fwrite((uint8_t[]){0xae, 0xb4, 0xb3, 0xb2, 0xa8, 0xa3, 0xa4, 0xff}, 1, 8, fptr);
    // Do not touch? Breaks contests?
    //05 8F 7A 8F 7A DF FF | かゼロゼロ_ | TODO ???
    //fwrite((uint8_t[]){0xef, 0xef, 0xef, 0xef, 0xef, 0xef, 0xff}, 1, 7, fptr);
};

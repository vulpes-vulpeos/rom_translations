#include "stdio.h"
#include <stdint.h>
#include <unistd.h>

#define ROM_PATH "/home/vulpeos/Downloads/pet_shop/Cute_Pet_Shop_Story.gbc"

size_t str_len(const uint8_t *s) {
    size_t i = 0;
    while (s[i] != 0xFF) { ++i; };
    return i+1;
}

#include "bank0E.c"
#include "bank0F.c"
#include "bank10.c"
#include "bank11.c"
#include "bank12.c"
#include "bank13.c"
#include "bank13_credits.c"
#include "bank13_items_names.c"
#include "bank13_menus.c"
#include "bank13_pets_kinds.c"
#include "bank13_pets_names.c"
#include "bank13_table3.c"
#include "bank13_towns_names.c"

int main(){
    // Open rom file
    FILE* fptr = fopen(ROM_PATH, "r+b");
    if (fptr == NULL) { printf("The file is not opened."); return 0; };
    FILE* eptr = fopen(ROM_PATH, "r+b"); // pointer for bank empty space
    if (fptr == NULL) { printf("The file is not opened."); return 0; };

    // --- bank 0x0E ---
    // - clients tasks
    // - kuma-kuma and somekind of stats plazas at the end
    if(b0E_table1(fptr)) { return 0; };
    // --- bank 0x0F ---
    // - NPC text
    // - signs
    if(b0F_table1(fptr)) { return 0; };
    // --- bank 0x10 ---
    // - items/meds descriptions
    // - npc text
    // - story text
    // - NPC thanks for meds/caretake
    fseek(eptr, 0x43765, SEEK_SET);
    if(b10_table1(fptr, eptr)) { return 0; };
    // - contests text
    // - overworld signs
    // - items effect apply text
    if(b10_table2(fptr, eptr)) { return 0; };
    printf("Space left in bank 0x10 empty section: %lu\n", 0x44000-ftell(eptr));
    // --- bank 0x11 ---
    // - clients tasks
    // - Suke hints
    // - Grandma answers
    // - ingredients descriptions
    // - unhappy customers
    // - TND-1 about due days
    fseek(eptr, 0x47cdd, SEEK_SET);
    if(b11_table1(fptr, eptr)) { return 0; };
    // - clients tasks and reactions
    // - receiveing an item text
    // - story text
    // - desease descriptions
    if(b11_table2(fptr, eptr)) { return 0; };
    printf("Space left in bank 0x11 empty section: %lu\n", 0x48000-ftell(eptr));
    // --- bank 0x12 ---
    // - story text
    // - pet kinds descriptions
    // - items descriptions
    fseek(eptr, 0x4b214, SEEK_SET);
    if(b12_table1(fptr, eptr)) { return 0; };
    if(b12_table2(fptr, eptr)) { return 0; };
    printf("Space left in bank 0x12 empty section: %lu\n", 0x4c000-ftell(eptr));
    // --- bank 0x13 ---
    // real data starts at 0x4c1bd (3rd table)
    if(b13_table3(fptr)) { return 0; };
    b13_menus(fptr);
    b13_items_names(fptr);
    b13_pets_kinds(fptr);
    b13_towns_names(fptr);
    b13_pets_names(fptr);
    //b13_credits(fptr);
    b13_other(fptr);

    // Translate terry name
    fseek(fptr, 0x1d917, SEEK_SET);
    fwrite((uint8_t[]){0xb3, 0xa4, 0xb1, 0xb1, 0xb8, 0xff }, 1, 6, fptr);
    // replacing Weight Class tiles
    fseek(fptr, 0x556f7, SEEK_SET);
    fwrite((uint8_t[]){0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x7F, 0x00, 0x80, 0x3B, 0xBB}, 1, 16, fptr);
    fwrite((uint8_t[]){0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x5D, 0x5D}, 1, 16, fptr);
    fwrite((uint8_t[]){0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x5C, 0x5C}, 1, 16, fptr);
    fwrite((uint8_t[]){0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x69, 0x69}, 1, 16, fptr);
    fwrite((uint8_t[]){0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xDB, 0xDB}, 1, 16, fptr);

    fwrite((uint8_t[]){0x3A, 0xBA, 0x3B, 0xBB, 0x3A, 0xBA, 0x1B, 0x9B, 0x00, 0x80, 0x80, 0x7F, 0x00, 0x00, 0x00, 0x00}, 1, 16, fptr);
    fwrite((uint8_t[]){0x11, 0x11, 0x55, 0x55, 0x55, 0x55, 0x5D, 0x5D, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00}, 1, 16, fptr);
    fwrite((uint8_t[]){0x48, 0x48, 0xC8, 0xC8, 0x48, 0x48, 0x48, 0x48, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00}, 1, 16, fptr);
    fwrite((uint8_t[]){0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x6D, 0x6D, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00}, 1, 16, fptr);
    fwrite((uint8_t[]){0x52, 0x52, 0xDB, 0xDB, 0x49, 0x49, 0x5B, 0x5B, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00}, 1, 16, fptr);
    //replace kg tile
    fseek(fptr, 0x5729f, SEEK_SET);
    fwrite((uint8_t[]){0x00, 0x00, 0xAF, 0xAF, 0xA8, 0xA8, 0xCB, 0xCB, 0xA9, 0xA9, 0xAF, 0xAF, 0x00, 0x00, 0x00, 0x00 }, 1, 16, fptr);
    fseek(fptr, 0x58dc0, SEEK_SET); // ' char (0xdc)
    fwrite((uint8_t[]){0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, 1, 16, fptr);
    fseek(fptr, 0x58e40, SEEK_SET); // ... char (0xe4)
    fwrite((uint8_t[]){0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xDB, 0xDB, 0xDB, 0xDB}, 1, 16, fptr);

    fclose(fptr);
}

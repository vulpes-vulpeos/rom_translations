#include <stdint.h>
#include <stdio.h>

void b13_menus(FILE* fptr) {
    // --- BLOCK 0x13: menu ---
    // [5 bytes][0xFF] 5th letter overlaps menu frame :(
    fseek(fptr, 0x4ccf6, SEEK_SET);
    //0x4ccf6 | 19 01 EF EF EF FF | はい | Yes
    fwrite((uint8_t[]){0xb8, 0xa4, 0xb2, 0xef, 0xef, 0xff}, 1, 6, fptr);
    //0x4ccfc | 01 01 03 EF EF FF | いいえ | No
    fwrite((uint8_t[]){0xad, 0xae, 0xef, 0xef, 0xef, 0xff}, 1, 6, fptr);
    //10 05 43 07 EF FF | ちかづく | Creep/Approach
    fwrite((uint8_t[]){0xa2, 0xb1, 0xa4, 0xa4, 0xaf, 0xff}, 1, 6, fptr);
    //03 0A EF EF EF FF |  えさ | Feed
    fwrite((uint8_t[]){0xa5, 0xa4, 0xa4, 0xa3, 0xef, 0xff}, 1, 6, fptr);
    //14 05 1E EF EF FF | なかま |  Pet/Party/Companions/Friends
    fwrite((uint8_t[]){0xaf, 0xa4, 0xb3, 0xef, 0xef, 0xff}, 1, 6, fptr);
    //19 14 0C EF EF FF | はなす | Talk
    fwrite((uint8_t[]){0xb3, 0xa0, 0xab, 0xaa, 0xef, 0xff}, 1, 6, fptr);
    //05 2D 0A 11 EF FF | かんさつ | Look/Watch/Observe
    fwrite((uint8_t[]){0xab, 0xae, 0xae, 0xaa, 0xef, 0xff}, 1, 6, fptr);
    //50 51 62 70 EF FF | アイテム | Item
    fwrite((uint8_t[]){0xa8, 0xb3, 0xa4, 0xac, 0xef, 0xff}, 1, 6, fptr);
    //1D 21 28 EF EF FF | ほめる | Pat/Treat/Praise
    fwrite((uint8_t[]){0xaf, 0xa0, 0xb3, 0xef, 0xef, 0xff}, 1, 6, fptr);
    //0B 11 08 28 EF FF | しつける | Teach
    fwrite((uint8_t[]){0xb3, 0xa4, 0xa0, 0xa2, 0xa7, 0xff}, 1, 6, fptr);
    //00 0E 48 EF EF FF | あそぶ | Play
    fwrite((uint8_t[]){0xaf, 0xab, 0xa0, 0xb8, 0xef, 0xff}, 1, 6, fptr);
    //23 0C 1F EF EF FF | やすみ | Sleep/Rest
    fwrite((uint8_t[]){0xb2, 0xab, 0xa4, 0xa4, 0xaf, 0xff}, 1, 6, fptr);
    //39 00 01 EF EF FF | ぐあい | Stats/Status
    fwrite((uint8_t[]){0xb2, 0xb3, 0xa0, 0xb3, 0xb2, 0xff}, 1, 6, fptr);
    //0x4CD44 | 19 0B 28 EF EF FF | はしる | Run
    fwrite((uint8_t[]){0xb1, 0xb4, 0xad, 0xef, 0xef, 0xff}, 1, 6, fptr);
    //0x0004CD4A | 02 2D 45 02 EF FF | うんどう  | Exercise
    fwrite((uint8_t[]){0xa4, 0xb7, 0xb1, 0xa2, 0xb2, 0xff}, 1, 6, fptr);
    //0x0004CD50 | 49 2D 06 35 02 FF | べんきょう | Study/Studying
    fwrite((uint8_t[]){0xb2, 0xb3, 0xb4, 0xa3, 0xb8, 0xff}, 1, 6, fptr);
    //0x0004CD56 | 63 77 6F 7D 89 FF | トリミング | Groom/Grooming
    fwrite((uint8_t[]){0xa6, 0xb1, 0xae, 0xae, 0xac, 0xff}, 1, 6, fptr);
    //0x0004CD5C | 14 0B EF EF EF FF | なし    | None
    fwrite((uint8_t[]){0xad, 0xae, 0xad, 0xa4, 0xef, 0xff}, 1, 6, fptr);
    fseek(fptr, 0x4cd62, SEEK_SET);
    //45 02 48 11 EF FF | どうぶつ | Pets/Animals
    fwrite((uint8_t[]){0xaf, 0xa4, 0xb3, 0xb2, 0xef, 0xff}, 1, 6, fptr);
    //0x0004CD68 | 51 99 7D 63 EF FF | イベント  | Event
    fwrite((uint8_t[]){0xa4, 0xb5, 0xa4, 0xad, 0xb3, 0xff}, 1, 6, fptr);
    //0x0004CD6E | 0D 36 12 01 EF FF | せってい  | Setup/Settings
    fwrite((uint8_t[]){0xb2, 0xa4, 0xb3, 0xb4, 0xaf, 0xff}, 1, 6, fptr);
    //0x0004CD74 | 5D CB 98 EF EF FF | セ-ブ   | Save
    fwrite((uint8_t[]){0xb2, 0xa0, 0xb5, 0xa4, 0xef, 0xff}, 1, 6, fptr);
    fseek(fptr, 0x4cd7a, SEEK_SET);
    //0x4CD7A | 07 0C 27 EF EF FF | くすり   | Meds/Medicine
    fwrite((uint8_t[]){0xac, 0xa4, 0xa3, 0xb2, 0xef, 0xff}, 1, 6, fptr);
    //05 02 EF EF EF FF | かう |  Buy
    fwrite((uint8_t[]){0xa1, 0xb4, 0xb8, 0xef, 0xef, 0xff}, 1, 6, fptr);
    //0x4CD86 | 02 28 EF EF EF FF | うる    | Sell
    fwrite((uint8_t[]){0xb2, 0xa4, 0xab, 0xab, 0xd7, 0xff}, 1, 6, fptr);
    //23 21 28 EF EF FF | やめる | Quit/Leave
    fwrite((uint8_t[]){0xb0, 0xb4, 0xa8, 0xb3, 0xef, 0xff}, 1, 6, fptr);
    //01 07 0D 01 EF FF | いくせい | Train
    fwrite((uint8_t[]){0xb3, 0xb1, 0xa0, 0xa8, 0xad, 0xff}, 1, 6, fptr);
    //01 29 05 03 EF FF | いれかえ | Party
    fwrite((uint8_t[]){0xaf, 0xa0, 0xb1, 0xb3, 0xb8, 0xff}, 1, 6, fptr);
    //0x4CD9E | 05 07 10 35 02 FF | かくちょう | Expnd
    fwrite((uint8_t[]){0xa4, 0xb7, 0xaf, 0xad, 0xa3, 0xff}, 1, 6, fptr);
    //0x4CDA4 | 05 08 36 09 EF FF | かけっこ  | Race/AGI
    fwrite((uint8_t[]){0xb1, 0xa0, 0xa2, 0xa4, 0xef, 0xff}, 1, 6, fptr);
    //0x4CDAA | 10 05 26 EF EF FF | ちから   | Push/STR
    fwrite((uint8_t[]){0xaf, 0xb4, 0xb2, 0xa7, 0xef, 0xff}, 1, 6, fptr);
    //0x4CDB0 | 3E 18 02 EF EF FF | ずのう   | Quiz/INT
    fwrite((uint8_t[]){0xb0, 0xb4, 0xa8, 0xb9, 0xef, 0xff}, 1, 6, fptr);
    //0x4CDB6 | 0B 33 0B 2D EF FF | しゃしん  | Photo/CTNS
    fwrite((uint8_t[]){0xaf, 0xa7, 0xae, 0xb3, 0xae, 0xff}, 1, 6, fptr);
    //0x4CDBC | 9E 86 63 EF EF FF | ペット   | Pet
    fwrite((uint8_t[]){0xaf, 0xa4, 0xb3, 0xef, 0xef, 0xff}, 1, 6, fptr);
    //0x4CDC2 | 9E 86 63 C2 EF FF | ペット2  | Pet2
    fwrite((uint8_t[]){0xaf, 0xa4, 0xb3, 0xef, 0xef, 0xff}, 1, 6, fptr);
    fseek(fptr, 0x4cdce, SEEK_SET);
    //0x4CDCE | 11 02 3D 35 02 FF | つうじょう | TODO Normal/Usual
    //fwrite((uint8_t[]){}, 1, 6, fptr);
    fseek(fptr, 0x4cdd4, SEEK_SET);
    //0x4CDD4 | 5A 52 7D 95 EF FF | サウンド  | Sound
    fwrite((uint8_t[]){0xb2, 0xae, 0xb4, 0xad, 0xa3, 0xff}, 1, 6, fptr);
    //0x4CDDA | 19 3D 21 05 26 FF | はじめから | New/New save file
    fwrite((uint8_t[]){0xad, 0xa4, 0xb6, 0xef, 0xef, 0xff}, 1, 6, fptr);
    fseek(fptr, 0x4cdec, SEEK_SET);
    //11 29 12 07 EF FF | つれてく | Take/Bring
    fwrite((uint8_t[]){0xb3, 0xa0, 0xaa, 0xa4, 0xef, 0xff}, 1, 6, fptr);
    //22 45 0C EF EF FF | もどす | Leave
    fwrite((uint8_t[]){0xab, 0xa4, 0xa0, 0xb5, 0xa4, 0xff}, 1, 6, fptr);
    //11 43 06 05 26 FF | つづきから | Load/Load save file
    fwrite((uint8_t[]){0xab, 0xae, 0xa0, 0xa3, 0xef, 0xff}, 1, 6, fptr);
    //71 65 84 CB EF FF | メニュ- | Menu
    fwrite((uint8_t[]){0xac, 0xa4, 0xad, 0xb4, 0xef, 0xff}, 1, 6, fptr);
    //3E 05 2D EF EF FF | ずかん | Bsmnt/Guide/Index/Album
    fwrite((uint8_t[]){0xa1, 0xb2, 0xac, 0xad, 0xb3, 0xff}, 1, 6, fptr);
    //0x4CE0A | 01 26 01 EF EF FF | いらい | Tasks/Requests/Orders
    fwrite((uint8_t[]){0xb3, 0xa0, 0xb2, 0xaa, 0xb2, 0xff}, 1, 6, fptr);
    //0x4CE10 | 24 02 0B 35 02 FF | ゆうしょう | 1st Place
    fwrite((uint8_t[]){0xc1, 0xb2, 0xb3, 0xef, 0xef, 0xff}, 1, 6, fptr);
    //0x4CE16 | C2 01 EF EF EF FF | 2い    | 2nd Place
    fwrite((uint8_t[]){0xc2, 0xad, 0xa3, 0xef, 0xef, 0xff}, 1, 6, fptr);
    fseek(fptr, 0x4ce22, SEEK_SET);
    //0x4CE22 | 71 86 5D CB 8D FF | メッセ-ジ | Msg/Message
    fwrite((uint8_t[]){0xac, 0xb2, 0xa6, 0xef, 0xef, 0xff}, 1, 6, fptr);
    //0x4CE28 | 08 DF DF DF DF DF DF DF DF FF | け________ | 
    //fwrite((uint8_t[]){}, 1, 10, fptr);
};

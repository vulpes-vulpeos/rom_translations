#include <stdint.h>
#include <stdio.h>

void b13_credits(FILE* fptr) {
    // --- BLOCK 0x13: credits ---
    /*
    fseek(fptr, 0x4DAFD, SEEK_SET);
    //0x0004DAFD | 10 05 2B 01 01 9E 86 63 5B 85 86 9D 22 18 37 0F 27 FF | ちかわいいペットショップものがたり | 
    fwrite((uint8_t[]){}, 1, 18, fptr);
    //0x0004DB0F | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DB20 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DB31 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DB42 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DB53 | EF EF EF EF EF BE 5C 5F 86 6B BF EF EF EF EF EF FF |      (スタッフ)      | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DB64 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DB75 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DB86 | EF EF EF D5 06 05 07 EF 3A 2D 00 2D D5 EF EF EF FF |    ・きかく げんあん・    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DB97 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DBA8 | EF EF EF EF 0C 38 23 1E EF 04 0A 20 EF EF EF EF FF |     すぎやま おさむ     | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DBB9 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DBCA | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DBDB | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DBEC | EF EF EF EF EF D5 06 05 07 D5 EF EF EF EF EF EF FF |      ・きかく・       | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DBFD | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DC0E | EF EF EF B8 AE B2 B2 A8 A4 EF 75 5B 91 EF EF EF FF |    YOSSIE ヨシダ    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DC1F | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DC30 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DC41 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DC52 | EF EF EF EF D5 5C 63 CB 77 CB D5 EF EF EF EF EF FF |     ・スト-リ-・      | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DC63 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DC74 | EF EF EF B8 AE B2 B2 A8 A4 EF 75 5B 91 EF EF EF FF |    YOSSIE ヨシダ    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DC85 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DC96 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DCA7 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DCB8 | EF EF EF D5 A1 A6 89 76 6B 7F 86 57 D5 EF EF EF FF |    ・BGグラフィック・    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DCC9 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DCDA | EF 0F 08 0B 0F B3 A0 AA A4 AC A0 AD 1E 14 48 EF FF |  たけしたTAKEMANまなぶ  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DCEB | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DCFC | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DD0D | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DD1E | EF EF D5 AC A0 AF 89 76 6B 7F 86 57 D5 EF EF EF FF |   ・MAPグラフィック・    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DD2F | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DD40 | EF 0F 08 0B 0F B3 A0 AA A4 AC A0 AD 1E 14 48 EF FF |  たけしたTAKEMANまなぶ  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DD51 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DD62 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DD73 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DD84 | EF D5 56 83 76 57 5F CB 89 76 6B 7F 86 57 D5 EF FF |  ・キャラクタ-グラフィック・  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DD95 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DDA6 | EF EF EF B8 AE B2 B2 A8 A4 EF 75 5B 91 EF EF EF FF |    YOSSIE ヨシダ    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DDB7 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DDC8 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DDD9 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DDEA | EF D5 9B 86 58 CB 8D 56 83 76 57 5F CB D5 EF EF FF |  ・パッケ-ジキャラクタ-・   | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DDFB | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DE0C | EF EF EF B8 AE B2 B2 A8 A4 EF 75 5B 91 EF EF EF FF |    YOSSIE ヨシダ    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DE1D | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DE2E | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DE3F | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DE50 | EF EF EF EF D5 9D 7A 89 76 70 D5 EF EF EF EF EF FF |     ・プログラム・      | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DE61 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DE72 | EF EF EF EF 04 04 01 0B EF 08 2D 23 EF EF EF EF FF |     おおいし けんや     | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DE83 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DE94 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DEA5 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DEB6 | EF EF EF EF D5 5C 57 77 9D 63 D5 EF EF EF EF EF FF |     ・スクリプト・      | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DEC7 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DED8 | EF EF EF EF 04 04 01 0B EF 08 2D 23 EF EF EF EF FF |     おおいし けんや     | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DEE9 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DEFA | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DF0B | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DF1C | EF EF EF D5 A5 A8 AD A4 5A 52 7D 95 D5 EF EF EF FF |    ・FINEサウンド・    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DF2D | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DF3E | EF 0A 36 06 35 07 EF EF EF EF EF EF EF EF EF EF FF |  さっきょく           | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DF4F | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DF60 | EF A2 A7 A8 A0 AA A8 EF EF BE B1 A4 A4 A1 BF EF FF |  CHIAKI  (REEB)  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DF71 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DF82 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DF93 | EF B2 A4 EF EF EF EF EF EF EF EF EF EF EF EF EF FF |  SE              | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DFA4 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DFB5 | EF B3 A0 AA A0 B2 B4 AA A4 BE B1 A4 A4 A1 BF EF FF |  TAKASUKE(REEB)  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DFC6 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DFD7 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DFE8 | EF 53 94 7F 86 63 EF EF EF EF EF EF EF EF EF EF FF |  エディット           | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004DFF9 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E00A | EF B8 A0 B2 B4 AA AE EF EF BE B1 A4 A4 A1 BF EF FF |  YASUKO  (REEB)  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E01B | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E02C | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E03D | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E04E | EF EF EF D5 0B 2D 09 02 EF 05 2D 27 D5 EF EF EF FF |    ・しんこう かんり・    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E05F | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E070 | EF EF EF B8 AE B2 B2 A8 A4 EF 75 5B 91 EF EF EF FF |    YOSSIE ヨシダ    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E081 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E092 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E0A3 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E0B4 | EF EF D5 5C 9E 5B 83 78 5A 7D 57 5C D5 EF EF EF FF |   ・スペシャルサンクス・    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E0C5 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E0D6 | EF EF EF EF 19 0B 3E EF 09 02 01 10 EF EF EF EF FF |     はしず こういち     | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E0E7 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E0F8 | EF EF EF EF 0B 1E 41 EF 0A 13 0B EF EF EF EF EF FF |     しまだ さとし      | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E109 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E11A | EF EF EF 0B 18 19 26 EF 13 0B 1A 09 EF EF EF EF FF |    しのはら としひこ     | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E12B | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E13C | EF EF EF EF 06 20 26 EF 13 22 00 06 EF EF EF EF FF |     きむら ともあき     | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E14D | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E15E | EF EF EF 0C 38 22 13 EF 1E 0C 1F EF EF EF EF EF FF |    すぎもと ますみ      | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E16F | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E180 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E191 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E1A2 | EF EF EF EF D5 94 7F 79 57 5F CB D5 EF EF EF EF FF |     ・ディレクタ-・     | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E1B3 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E1C4 | EF EF EF EF 2B 0F 14 49 EF 1A 2A 09 EF EF EF EF FF |     わたなべ ひろこ     | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E1D5 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E1E6 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E1F7 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E208 | EF EF EF D5 9D 7A 94 84 CB 5A CB D5 EF EF EF EF FF |    ・プロデュ-サ-・     | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E219 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E22A | EF EF EF EF EF 45 01 EF 1E 0A 04 EF EF EF EF EF FF |      どい まさお      | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E23B | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E24C | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E25D | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E26E | D5 53 89 8F 57 62 7F 98 9D 7A 94 84 CB 5A CB D5 FF | ・エグゼクティブプロデュ-サ-・ | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E27F | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E290 | EF EF EF 3B 02 19 26 EF 27 35 02 40 02 EF EF EF FF |    ごうはら りょうぞう    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E2A1 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E2B2 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E2C3 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E2D4 | EF EF D5 10 35 0A 07 D5 0D 01 0A 07 D5 EF EF EF FF |   ・ちょさく・せいさく・    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E2E5 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E2F6 | EF EF EF 59 59 64 86 61 EF 8D 83 9B 7D EF EF EF FF |    ココナッツ ジャパン    | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E307 | EF EF EF 53 7D 5F CB 62 51 71 7D 63 EF EF EF EF FF |    エンタ-テイメント     | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E318 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E329 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E33A | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E34B | EF EF EF EF D5 19 2D 46 01 22 13 D5 EF EF EF EF FF |     ・はんばいもと・     | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E35C | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E36D | EF EF EF EF EF EF 5F 51 63 CB EF EF EF EF EF EF FF |       タイト-       | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E37E | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E38F | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E3A0 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E3B1 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E3C2 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E3D3 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E3E4 | EF D2 EF C1 C9 C9 C9 EF EF EF EF EF EF EF EF EF FF |  © 1999          | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E3F5 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E406 | EF A2 AE A2 AE AD B4 B3 B2 EF A9 A0 AF A0 AD EF FF |  COCONUTS JAPAN  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E417 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E428 | EF A4 AD B3 A4 B1 B3 A0 A8 AD AC A4 AD B3 EF EF FF |  ENTERTAINMENT   | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E439 | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E44A | EF A2 AE DA D9 AB B3 A3 DA EF EF EF EF EF EF EF FF |  CO.,LTD.        | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    //0x0004E45B | EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF EF FF |                  | 
    fwrite((uint8_t[]){}, 1, 17, fptr);
    */
};
